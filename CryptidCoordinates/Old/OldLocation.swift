//
//  Location.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 1/9/24.
//

import MapKit

struct OldLocation: Codable, Hashable, Identifiable {
    let location: String
    let country: String
    let city: String
    let state: String
    let description: String
    let longitude: String
    let latitude: String
    let cityLongitude: String
    let cityLatitude: String
    let stateAbbrev: String
}

// MARK: util
extension OldLocation {
    var name: String {
        location
    }
    
    var id: String {
        UUID().uuidString
    }
    
    var coordinates: CLLocationCoordinate2D {
        if let x = Double(latitude) {
            if let y = Double(longitude) {
                return CLLocationCoordinate2D(latitude: x, longitude: y)
            }
        }
        return CLLocationCoordinate2D()
    }

    var cityCoordinates: CLLocationCoordinate2D {
        if let x = Double(cityLatitude) {
            if let y = Double(cityLongitude) {
                return CLLocationCoordinate2D(latitude: x, longitude: y)
            }
        }
        return CLLocationCoordinate2D()
    }
    
    var cityState: String {
        "\(city), " + "\(stateAbbrev)"
    } 
}

// MARK: Developer
extension OldLocation {
    static let example = OldLocation(location: "Rosemount Museum", country: "United States", city: "Pueblo", state: "Colorado", description: "The museum was home to the prominent Pueblo family, the Thatcher’s, during the 1800's. There are noises and movements all over the property as well as a real Egyptian Mummy in one of the top stories. Under their house there are extensive tunnels not open to the public.", longitude: "-104.6121005", latitude: "38.2805245", cityLongitude: "-104.6091409", cityLatitude: "38.2544472", stateAbbrev: "CO")
    
    static let exampleArray = Array<OldLocation>.init(repeating: example, count: 10)
    
    static let allLocations: [OldLocation] = Bundle.main.decode(file: "hauntedplaces.json")
}
