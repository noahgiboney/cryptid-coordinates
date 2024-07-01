//
//  ViewModel.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/14/24.
//

import Firebase
import SwiftUI

@Observable
class ViewModel {
    private let firebaseService: FirebaseService
    var user: User
    
    init(firebaseService: FirebaseService = FirebaseService.shared, user: User) {
        self.firebaseService = firebaseService
        self.user = user
    }
    
    var locations: [OldLocation] = []
    var count = 0
    var tabSelection = 0
    
    func fetchAllLocations() async throws {
        do {
            count = try await firebaseService.fetchAllLocations()
        } catch {
            print("DEBUG: error fetching all locations: \(error.localizedDescription)")
        }
    }
}

// MARK: comments
extension ViewModel {
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
