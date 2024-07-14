//
//  CommentModel.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 7/14/24.
//

import Foundation

@Observable
class CommentModel {
    var comments: [Comment] = []
    var didLoad = false
    
    func fetchComments(locationId id: String) async throws {
        do {
            comments = try await CommentService.shared.fetchComments(locationId: id)
        } catch {
            print("Error: ")
        }
    }
}
