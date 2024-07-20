//
//  Location.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/15/24.
//

import SwiftUI
import MapKit

struct LocationStats: Codable, Equatable, Hashable {
    var likes: Int
    var comments: Int
}

struct Location: Codable, Identifiable, Hashable {
    
    /// firestore data
    var id: String
    let name: String
    let country: String
    let city: String
    let state: String
    let description: String
    let longitude: Double
    let latitude: Double
    let cityLongitude: Double
    let cityLatitude: Double
    let stateAbbrev: String
    var imageUrl: String?
    var geohash: String
    var stats: LocationStats?
    var done: String?
    
    /// local properties
    var didSave = false
    
    enum CodingKeys: String, CodingKey {
        case id
        case name = "location"
        case country
        case city
        case state
        case description
        case longitude
        case latitude
        case cityLongitude
        case cityLatitude
        case stateAbbrev
        case imageUrl
        case geohash
        case stats
        case done
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.country = try container.decode(String.self, forKey: .country)
        self.city = try container.decode(String.self, forKey: .city)
        self.state = try container.decode(String.self, forKey: .state)
        self.description = try container.decode(String.self, forKey: .description)
        self.longitude = try container.decode(Double.self, forKey: .longitude)
        self.latitude = try container.decode(Double.self, forKey: .latitude)
        self.cityLongitude = try container.decode(Double.self, forKey: .cityLongitude)
        self.cityLatitude = try container.decode(Double.self, forKey: .cityLatitude)
        self.stateAbbrev = try container.decode(String.self, forKey: .stateAbbrev)
        self.imageUrl = try? container.decode(String?.self, forKey: .imageUrl)
        self.geohash = try container.decode(String.self, forKey: .geohash)
        self.stats = try? container.decode(LocationStats?.self, forKey: .stats)
        self.done = try? container.decode(String?.self, forKey: .done)
    }
    
    init(
        id: String,
        name: String,
        country: String,
        city: String,
        state: String,
        description: String,
        longitude: Double,
        latitude: Double,
        cityLongitude: Double,
        cityLatitude: Double,
        stateAbbrev: String,
        imageUrl: String? = nil,
        geohash: String,
        stats: LocationStats? = nil,
        done: String? = nil
    ) {
        self.id = id
        self.name = name
        self.country = country
        self.city = city
        self.state = state
        self.description = description
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
        if let imageUrl{
            return URL(string: imageUrl)
        }
        return nil
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
    static let example = Location(id: UUID().uuidString, name: "Rosemount Museum", country: "United States", city: "Pueblo", state: "Colorado", description: "The museum was home to the prominent Pueblo family, the Thatcher’s, during the 1800's. There are noises and movements all over the property as well as a real Egyptian Mummy in one of the top stories. Under their house there are extensive tunnels not open to the public.", longitude: -104.6121005, latitude: 38.2805245, cityLongitude: -104.6091409, cityLatitude: 38.2544472, stateAbbrev: "CO", imageUrl: "https://upload.wikimedia.org/wikipedia/commons/e/ef/Newberry_College_Historic_District.jpg", geohash: "")
    
    static let exampleArray = Array<Location>.init(repeating: example, count: 10)
}
