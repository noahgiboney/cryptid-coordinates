//
//  User.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/15/24.
//

import MapKit
import Foundation

struct User: Codable, Identifiable, Equatable {
    var id: String
    var name: String
    var profilePicture = ProfilePicture.person
    var score = 0
    
    var latitude: Double?
    var longitude: Double?
    
    static func ==(lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.profilePicture == rhs.profilePicture
    }
}

// MARK: Util
extension User {
    var location: CLLocationCoordinate2D? {
        if let latitude, let longitude{
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        return nil
    }
}

// MARK: Developer
extension User {
    static let example = User(id: UUID().uuidString, name: "Noah Giboney", profilePicture: .killer)
}
