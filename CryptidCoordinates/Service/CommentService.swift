//
//  CommentService.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 7/14/24.
//

import Firebase
import Foundation

class CommentService {
    static let shared = CommentService()
    
    private init () {}
    
    func commentCollection(_ locationId: String) -> CollectionReference {
        return Firestore.firestore().collection("comments").document(locationId).collection("comments")
    }
    
    func fetchComments(locationId: String) async throws -> [Comment] {
        try await withThrowingTaskGroup(of: (Comment, User).self) { taskGroup in
            let snapshot = try await commentCollection(locationId).order(by: "timestamp", descending: true).getDocuments()
            let comments = snapshot.documents.compactMap( { try? $0.data(as: Comment.self)} )
            for comment in comments {
                taskGroup.addTask {
                    let user = try await UserService.shared.fetchUser(userId: comment.userId)
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
        let encodedComment = try Firestore.Encoder().encode(comment)
        try await commentCollection(comment.locationId).document(comment.id).setData(encodedComment)
    }
    
    func deleteComment(locationId: String, commentId: String) async throws {
        try await commentCollection(locationId).document(commentId).delete()
    }
    
    func fetchTotalComments(locationId: String) async throws -> Int {
        return try await commentCollection(locationId).getDocuments().count
    }
}
