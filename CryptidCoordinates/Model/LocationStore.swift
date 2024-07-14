//
//  ExploreModel.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 7/10/24.
//

import CoreLocation
import Foundation

@Observable
class LocationStore {
    var locations: [Location] = []
    var loadState: LoadState = .loading
    
    func fetchNearLocations(userCords: CLLocationCoordinate2D) async throws {
        do {
            locations = try await LocationService.shared.fetchNearestLocations(for: userCords)
            print(locations.count)
        } catch {
            print("ERROR: \(error.localizedDescription)")
        }
    }
}
