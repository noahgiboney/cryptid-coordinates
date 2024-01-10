//
//  HauntedLocation.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 1/9/24.
//

import Foundation
import MapKit

struct HauntedLocation: Codable, Hashable, Identifiable {
    let location: String
    let country: String
    let city: String
    let description: String
    let longitude: String
    let latitude: String
    
    var name: String {
        location
    }
    
    var id: UUID {
        UUID()
    }
    
    var coordinates: CLLocationCoordinate2D {
        if let x = Double(latitude) {
            if let y = Double(longitude) {
                return CLLocationCoordinate2D(latitude: x, longitude: y)
            }
        }
        return CLLocationCoordinate2D()
    }
    
    static let example = HauntedLocation(location: "Simi Valley Hospital", country: "United States", city: "Simi Valley", description: "This place has been know to have ghosts waking around", longitude: "0", latitude: "0")
}
