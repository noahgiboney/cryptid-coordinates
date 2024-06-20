//
//  Comment.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/18/24.
//

import Firebase
import Foundation

struct Comment: Codable, Identifiable {
    var id: String
    var userId: String
    var userName: String
    var locationId: String
    var content: String
    var timestamp: Timestamp
}

// MARK: Developer
extension Comment {
    static let example = Comment(id: UUID().uuidString, userId: UUID().uuidString, userName: User.example.name, locationId: UUID().uuidString, content: "Such a cool place wow!", timestamp: Timestamp())
    
    static let exampleArray: [Comment] = Array.init(repeating: .example, count: 5)
}
