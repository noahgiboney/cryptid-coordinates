//
//  CommentModel.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 7/14/24.
//

import Observation
import Firebase
import Foundation

enum CommentLoadState {
    case loaded, loading, empty
}

@Observable
class CommentModel {
    var comment = ""
    var comments: [Comment] = []
    var loadState: CommentLoadState = .loading
    
    func fetchComments(locationId id: String) async throws {
        loadState = .loading
        do {
            comments = try await CommentService.shared.fetchComments(locationId: id)
            
            if comments.isEmpty {
                loadState = .empty
            } else {
                loadState = .loaded
            }
        } catch {
            print("Error: fetchComments(): \(error.localizedDescription)")
        }
    }
    
    func addComment(locationId: String, currentUser: User) async throws -> String? {
        guard let user = Auth.auth().currentUser else { return nil }
        var newComment = Comment(userId: user.uid, locationId: locationId, content: comment)
        
        do {
            try await CommentService.shared.addComment(comment: newComment)
            newComment.user = currentUser
            comments.insert(newComment, at: 0)
            comment = ""
            return newComment.id
        } catch {
            print("Error: addComment(): \(error.localizedDescription)")
        }
        return nil
    }
    
    func deleteComment(_ comment: Comment) async throws {
        do {
            try await CommentService.shared.deleteComment(locationId: comment.locationId, commentId: comment.id)
            
            if let index = comments.firstIndex(where: { $0.id == comment.id }) {
                comments.remove(at: index)
            }
        } catch {
            print("Error: deleteComment(): \(error.localizedDescription)")
        }
    }
    
    func reportComment(_ comment: Comment) async throws {
        do {
            try await CommentService.shared.reportComment(comment: comment)
        } catch {
            print("Error: reportComment(): \(error.localizedDescription)")
        }
    }
}
