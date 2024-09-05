//
//  Visit.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 7/9/24.
//

import Firebase
import Foundation

struct Visit: DataModel {
    var id = UUID().uuidString
    var timestamp = Timestamp()
    var userId: String
    var locationId: String
}

// MARK: Developer
extension Visit  {
    static let example = Visit(userId: UUID().uuidString, locationId: Location.example.id)
}
