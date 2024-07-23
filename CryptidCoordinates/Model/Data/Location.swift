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
class Location: Identifiable, Hashable, Codable {
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
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case country
        case city
        case state
        case detail
        case longitude
        case latitude
        case cityLongitude
        case cityLatitude
        case stateAbbrev
        case imageUrl
        case geohash
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.country = try container.decode(String.self, forKey: .country)
        self.city = try container.decode(String.self, forKey: .city)
        self.state = try container.decode(String.self, forKey: .state)
        self.detail = try container.decode(String.self, forKey: .detail)
        self.longitude = try container.decode(Double.self, forKey: .longitude)
        self.latitude = try container.decode(Double.self, forKey: .latitude)
        self.cityLongitude = try container.decode(Double.self, forKey: .cityLongitude)
        self.cityLatitude = try container.decode(Double.self, forKey: .cityLatitude)
        self.stateAbbrev = try container.decode(String.self, forKey: .stateAbbrev)
        self.imageUrl = try container.decode(String.self, forKey: .imageUrl)
        self.geohash = try container.decode(String.self, forKey: .geohash)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(country, forKey: .country)
        try container.encode(city, forKey: .city)
        try container.encode(state, forKey: .state)
        try container.encode(detail, forKey: .detail)
        try container.encode(longitude, forKey: .longitude)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(cityLongitude, forKey: .cityLongitude)
        try container.encode(stateAbbrev, forKey: .stateAbbrev)
        try container.encode(imageUrl, forKey: .imageUrl)
        try container.encode(geohash, forKey: .geohash )
    }
    
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
    
    func distanceAway(userCords: CLLocationCoordinate2D) -> String {
        let distance = userCords.distance(from: clLocation)
        return roundToTenth((distance / 1609))
    }
}

// MARK: Developer
extension Location {
    static let example = Location(id: UUID().uuidString, name: "Rosemount Museum", country: "United States", city: "Pueblo", state: "Colorado", detail: "The museum was home to the prominent Pueblo family, the Thatcher’s, during the 1800's. There are noises and movements all over the property as well as a real Egyptian Mummy in one of the top stories. Under their house there are extensive tunnels not open to the public.", longitude: -104.6121005, latitude: 38.2805245, cityLongitude: -104.6091409, cityLatitude: 38.2544472, stateAbbrev: "CO", imageUrl: "https://upload.wikimedia.org/wikipedia/commons/e/ef/Newberry_College_Historic_District.jpg", geohash: "")
    
    static let exampleArray = Array<Location>.init(repeating: example, count: 10)
}
