//
//  LocationService.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 7/10/24.
//

import CoreLocation
import Firebase
import Foundation

class LocationService {
    static let shared = LocationService()
    var nearestLocations: [Location] = []
    
    private init () {}

}

// MARK: - trending

extension LocationService {
    func fetchTrending() async throws -> [String] {
        let trendingRef = Firestore.firestore().collection("trending")
        let snapshot = try await trendingRef.getDocuments()
        return snapshot.documents.compactMap { $0.documentID }
    }
}
