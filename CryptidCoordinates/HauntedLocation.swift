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
    
    static let example = HauntedLocation(location: "Simi Valley", country: "United States", city: "Simi Valley", description: "There are reports of an apparition of a woman being chased by hounds, children playing on the train tracks below, and sounds of a baby crying.- February 2004 Correction – Additional Information: You can also hear footsteps and see footprints, but no one is there.", longitude: "0", latitude: "0")
}
