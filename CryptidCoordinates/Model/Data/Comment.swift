//
//  Comment.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/18/24.
//

import Firebase
import Foundation

struct Comment: Codable, Identifiable {
    var id = UUID().uuidString
    var userId: String
    var locationId: String
    var content: String
    var timestamp = Timestamp()
    
    var user: User?
}

// MARK: Developer
extension Comment {
    static let example = Comment(id: UUID().uuidString, userId: UUID().uuidString, locationId: UUID().uuidString, content: "Such a cool place wow!", timestamp: Timestamp())
    
    static let exampleArray: [Comment] = Array.init(repeating: .example, count: 5)
}
