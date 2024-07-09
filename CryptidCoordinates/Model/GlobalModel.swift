//
//  ViewModel.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/14/24.
//

import Firebase
import SwiftUI

@Observable
class GlobalModel {
    private let firebaseService: FirebaseService
    private let userService: UserService
    var user: User
    
    init(
        firebaseService: FirebaseService = .shared,
        userService: UserService = .shared ,
        user: User
    ) {
        self.firebaseService = firebaseService
        self.userService = userService
        self.user = user
    }
    
    var locations: [OldLocation] = []
    var count = 0
    var tabSelection = 0
    
    var selectedLocation: Location? {
        didSet {
            tabSelection = 1
        }
    }
    
    func fetchAllLocations() async throws {
        do {
            count = try await firebaseService.fetchAllLocations()
        } catch {
            print("DEBUG: error fetching all locations: \(error.localizedDescription)")
        }
    }
}

// MARK: profile
extension GlobalModel {
//    func updateUser(updatedUser: User) async throws {
//        do {
//            try await userService.updateUser(updatedUser: updatedUser)
//        } catch {
//            print("DEBUG: failed to update user. \(error.localizedDescription)")
//        }
//    }
}

// MARK: comments
extension GlobalModel {
    func fetchComments(locationId: String) async throws -> [Comment]{
        do {
            return try await firebaseService.fetchComments(locationId: locationId)
        } catch {
            print("DEBUG: error fetching comments: \(error.localizedDescription)")
            throw error
        }
    }
    
    func addComment(content: String, locationId: String) async throws {
        guard let user = Auth.auth().currentUser else { return }
        let newComment = Comment(userId: user.uid, locationId: locationId, content: content)
        
        do {
            try await firebaseService.addComment(comment: newComment)
        } catch {
            print("DEBUG: error adding comment: \(error.localizedDescription)")
        }
    }
    
    func deleteComment(_ comment: Comment) async throws{
        do {
            try await firebaseService.deleteComment(locationId: comment.locationId, commentId: comment.id)
        } catch {
            print("DEBUG: error deleting comment: \(error.localizedDescription)")
        }
    }
}
