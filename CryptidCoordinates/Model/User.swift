//
//  User.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/15/24.
//

import Firebase
import Foundation
import MapKit

struct User: DataModel, Equatable {
    var id: String
    var name: String
    var avatar = Avatar.killer
    var joinTimestamp = Timestamp()
    var visits = 0
    
    var latitude: Double?
    var longitude: Double?
    
    static func ==(lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.avatar == rhs.avatar
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
    
    var joinDate: String {
        return joinTimestamp.dateValue().formatted(date: .complete, time: .omitted)
    }
    
    var username: String {
        name.isEmpty ? "Anonymous" : name
    }
}

// MARK: Developer
extension User {
    static let example = User(id: UUID().uuidString, name: "Noah Giboney", avatar: .killer)
    
    static let exampleLeaderboard : [User] = [User(id: UUID().uuidString, name: "Noah", avatar: .nun),
                                              User(id: UUID().uuidString, name: "Xio", avatar: .clown),
                                              User(id: UUID().uuidString, name: "Lil Uzi Vert", avatar: .satan),
                                              User(id: UUID().uuidString, name: "Vinny", avatar: .killer),
                                              User(id: UUID().uuidString, name: "Patito", avatar: .clown),
                                              User(id: UUID().uuidString, name: "Camellia Cabello", avatar: .satan),
                                              User(id: UUID().uuidString, name: "Grimance", avatar: .skeleton),
                                              User(id: UUID().uuidString, name: "Inca Kola", avatar: .killer),
                                              User(id: UUID().uuidString, name: "Young Thug", avatar: .alien),
                                              User(id: UUID().uuidString, name: "Annitta", avatar: .goblin)
                                              
    ]
}
