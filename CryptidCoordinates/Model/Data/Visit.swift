//
//  Visit.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 7/9/24.
//

import Firebase
import Foundation

struct Visit: Identifiable, Codable {
    var id = UUID().uuidString
    var timestamp = Timestamp()
    var userId: String
    var locationId: String
    
    var location: Location?
}

// MARK: Developer
extension Visit  {
    static let example = Visit(userId: UUID().uuidString, locationId: Location.example.id, location: Location.example)
}
