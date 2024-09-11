//
//  CommentSection.swift
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
class CommentSection {
    var comment = ""
    var comments: [Comment] = []
    var loadState: CommentLoadState = .loading
    
    func fetchComments(_ locationId: String) async {
        do {
            comments = try await FirebaseService.shared.fetchData(ref: Collections.locationComments(for: locationId))
            
            await fetchUserForComments()
            
            comments = comments.sorted { $0.timestamp.dateValue() > $1.timestamp.dateValue() }.filter { $0.user != nil }
            
            if comments.isEmpty {
                loadState = .empty
            } else {
                loadState = .loaded
            }
        } catch {
            print("Error: fetchComments(): \(error.localizedDescription)")
        }
    }
    
    func addNewComment(for locationId: String, currentUser: User) async -> String? {
        guard let user = Auth.auth().currentUser else { return nil }
        
        do {
            var newComment = Comment(userId: user.uid, locationId: locationId, content: comment)
            
            try await FirebaseService.shared.setData(object: newComment, ref: Collections.locationComments(for: locationId))
            
            newComment.user = currentUser
            
            comments.insert(newComment, at: 0)
            comment = ""
            
            return newComment.id
        } catch {
            print("Error: addComment(): \(error.localizedDescription)")
        }
        return nil
    }
    
    func deleteComment(_ comment: Comment) {
        FirebaseService.shared.delete(id: comment.id, ref: Collections.locationComments(for: comment.locationId))
        
        if let index = comments.firstIndex(where: { $0.id == comment.id }) {
            comments.remove(at: index)
        }
    }
    
    func reportComment(_ comment: Comment) async throws {
        do {
            let newReport = ReportedComment(commentId: comment.id, content: comment.content, locationId: comment.locationId)
            try await FirebaseService.shared.setData(object: newReport, ref: Collections.reportedComments)
        } catch {
            print("Error: reportComment(): \(error.localizedDescription)")
        }
    }
    
    @MainActor
    private func fetchUserForComments() async {
        await withTaskGroup(of: (User?, String).self) { groupTask in
            for comment in comments {
                groupTask.addTask {
                    let user: User? = try? await FirebaseService.shared.fetchOne(id: comment.userId, ref: Collections.users)
                    return (user, comment.id)
                }
            }
            
            for await (user, commentId) in groupTask {
                if let user {
                    if let index = comments.firstIndex(where: { $0.id == commentId }) {
                        comments[index].user = user
                    }
                }
            }
        }
    }
}
