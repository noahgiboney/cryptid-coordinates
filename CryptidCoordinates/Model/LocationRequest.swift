//
//  LocationRequest.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/29/24.
//

import Firebase
import Foundation

struct LocationRequest: DataModel {
    var id = UUID().uuidString
    let user: String
    let locationName: String
    let description: String
    let latitude: Double
    let longitude: Double
    let isAnonymous: Bool
    var timestamp = Timestamp()
}
