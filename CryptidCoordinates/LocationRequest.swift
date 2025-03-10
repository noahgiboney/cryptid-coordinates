//
//  LocationRequest.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/29/24.
//

import Foundation

struct LocationRequest: Codable {
    var user: String
    var locationName: String
    var description: String
    var latitude: Double
    var longitude: Double
}
