//
//  User.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/15/24.
//

import Foundation

struct User: Codable, Identifiable {
    var id: String
    var name: String
    var profilePicture = ProfilePicture.person
}

// MARK: Developer
extension User {
    static let example = User(id: UUID().uuidString, name: "Noah Giboney", profilePicture: .killer)
}
