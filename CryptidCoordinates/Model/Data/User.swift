//
//  User.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/15/24.
//

import Foundation

struct User: Codable, Identifiable, Equatable {
    var id: String
    var name: String
    var profilePicture = ProfilePicture.person
    
    static func ==(lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.profilePicture == rhs.profilePicture
    }
}

// MARK: Developer
extension User {
    static let example = User(id: UUID().uuidString, name: "Noah Giboney", profilePicture: .killer)
}
