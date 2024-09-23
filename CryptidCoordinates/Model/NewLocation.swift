//
//  NewLocation.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 9/7/24.
//

import Firebase
import Foundation

struct NewLocation: DataModel, Comparable {
    var id: String
    let name: String
    let country: String
    let city: String
    let state: String
    let detail: String
    let longitude: Double
    let latitude: Double
    let cityLongitude: Double
    let cityLatitude: Double
    let stateAbbrev: String
    let imageUrl: String
    let geohash: String
    let userId: String?
    let timestamp: Timestamp
    
    var user: User?
    
    static func <(lhs: NewLocation, rhs: NewLocation) -> Bool {
        return lhs.timestamp.dateValue() > rhs.timestamp.dateValue()
    }
    
    static let example = NewLocation(id: UUID().uuidString, name: "", country: "", city: "", state: "", detail: "", longitude: 3, latitude: 3, cityLongitude: 3, cityLatitude: 3, stateAbbrev: "", imageUrl: "", geohash: "", userId: "", timestamp: .init())
}
