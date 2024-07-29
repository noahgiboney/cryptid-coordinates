//
//  Location.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/15/24.
//

import SwiftData
import SwiftUI
import MapKit

@Model
class Location: Identifiable, Hashable {
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
    
    init(id: String, name: String, country: String, city: String, state: String, detail: String, longitude: Double, latitude: Double, cityLongitude: Double, cityLatitude: Double, stateAbbrev: String, imageUrl: String, geohash: String) {
        self.id = id
        self.name = name
        self.country = country
        self.city = city
        self.state = state
        self.detail = detail
        self.longitude = longitude
        self.latitude = latitude
        self.cityLongitude = cityLongitude
        self.cityLatitude = cityLatitude
        self.stateAbbrev = stateAbbrev
        self.imageUrl = imageUrl
        self.geohash = geohash
    }
}

// MARK: Util
extension Location {
    var coordinates: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var cityCoordinates: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: cityLatitude, longitude: cityLongitude)
    }
    
    var cityStateLong: String {
        "\(city), " + "\(state)"
    }
    
    var cityState: String {
        "\(city), " + "\(stateAbbrev)"
    }
    
    var url: URL? {
        return URL(string: imageUrl)
    }
    
    var cameraPosition: MapCameraPosition {
        .region(MKCoordinateRegion(center: coordinates, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)))
    }
    
    var clLocation: CLLocation {
        CLLocation(latitude: latitude, longitude: longitude)
    }
    
    func distanceAway(_ userCords: CLLocationCoordinate2D) -> String {
        let distance = userCords.distance(from: clLocation)
        return roundToTenth((distance / 1609))
    }
}

// MARK: Developer
extension Location {
    static let example = Location(id: UUID().uuidString, name: "Rosemount Museum", country: "United States", city: "Pueblo", state: "Colorado", detail: "The museum was home to the prominent Pueblo family, the Thatcher’s, during the 1800's. There are noises and movements all over the property as well as a real Egyptian Mummy in one of the top stories. Under their house there are extensive tunnels not open to the public.", longitude: -104.6121005, latitude: 38.2805245, cityLongitude: -104.6091409, cityLatitude: 38.2544472, stateAbbrev: "CO", imageUrl: "https://upload.wikimedia.org/wikipedia/commons/e/ef/Newberry_College_Historic_District.jpg", geohash: "")
    
    static let example2 = Location(id: UUID().uuidString, name: "Rosemount Museum", country: "United States", city: "Pueblo", state: "Colorado", detail: "The museum was home to the prominent Pueblo family, the Thatcher’s, during the 1800's. There are noises and movements all over the property as well as a real Egyptian Mummy in one of the top stories. Under their house there are extensive tunnels not open to the public.", longitude: -104.6121005, latitude: 38.2805245, cityLongitude: -104.6091409, cityLatitude: 38.2544472, stateAbbrev: "CO", imageUrl: "https://upload.wikimedia.org/wikipedia/commons/e/ef/Newberry_College_Historic_District.jpg", geohash: "")
    
    static let example3 = Location(id: UUID().uuidString, name: "Rosemount Museum", country: "United States", city: "Pueblo", state: "Colorado", detail: "The museum was home to the prominent Pueblo family, the Thatcher’s, during the 1800's. There are noises and movements all over the property as well as a real Egyptian Mummy in one of the top stories. Under their house there are extensive tunnels not open to the public.", longitude: -104.6121005, latitude: 38.2805245, cityLongitude: -104.6091409, cityLatitude: 38.2544472, stateAbbrev: "CO", imageUrl: "https://upload.wikimedia.org/wikipedia/commons/e/ef/Newberry_College_Historic_District.jpg", geohash: "")
    
    static let exampleArray: [Location] = [.example, .example2, .example3]
}
