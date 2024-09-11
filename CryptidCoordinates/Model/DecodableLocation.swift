//
//  DecodableLocation.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 7/23/24.
//

import Foundation

struct DecodableLocation: DataModel {
    var id: String
    var name: String
    var country: String
    var city: String
    var state: String
    var detail: String
    var longitude: Double
    var latitude: Double
    var cityLongitude: Double
    var cityLatitude: Double
    var stateAbbrev: String
    var imageUrl: String
    var geohash: String
}
