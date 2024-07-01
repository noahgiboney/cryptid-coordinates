//
//  FirestoreClient.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/14/24.
//

import Firebase
import FirebaseCore
import Foundation

class FirebaseService {
    static let shared = FirebaseService()
    
    private init () {}
    
    private let db = Firestore.firestore()
    private let encoder = Firestore.Encoder()
    
    func fetchAllLocations() async throws -> Int {
        let snapshot = try await db.collection("locations").getDocuments()
        return snapshot.documents.count
    }
    
//    func fetchLocation(id: String) async throws -> Location {
//        let snapshot = try await Firestore.firestore().collection("locations").whereField("id", isEqualTo: id).getDocuments()
//
//    }
    
    func fetchUser(userId: String) async throws -> User {
        return try await db.collection("users").document(userId).getDocument(as: User.self)
    }
    
    func submitRequest(location: LocationRequest) async throws {
        let encodedLocation = try Firestore.Encoder().encode(location)
        try await db.collection("locationRequests").document(location.locationName).setData(encodedLocation)
    }
}


// MARK: comments
extension FirebaseService {
    func commentCollection(locationId: String) -> CollectionReference {
        return db.collection("comments").document(locationId).collection("comments")
    }
    
    func fetchComments(locationId: String) async throws -> [Comment] {
        try await withThrowingTaskGroup(of: (Comment, User).self) { taskGroup in
            let snapshot = try await commentCollection(locationId: locationId).getDocuments()
            var comments = snapshot.documents.compactMap( { try? $0.data(as: Comment.self)} )
            
            for comment in comments {
                taskGroup.addTask { [self] in
                    let user = try await fetchUser(userId: comment.userId)
                    return (comment, user)
                }
            }
            
            var updatedComments: [Comment] = []
            for try await (comment, user) in taskGroup {
                var updatedCommnet = comment
                updatedCommnet.user = user
                updatedComments.append(updatedCommnet)
            }
            
            return updatedComments
        }
    }
    
    func addComment(comment: Comment) async throws {
        let encodedComment = try encoder.encode(comment)
        try await commentCollection(locationId: comment.locationId).document(comment.id).setData(encodedComment)
    }
    
    func deleteComment(locationId: String, commentId: String) async throws {
        try await commentCollection(locationId: locationId).document(commentId).delete()
    }
}
