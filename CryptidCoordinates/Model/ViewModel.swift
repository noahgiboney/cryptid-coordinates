//
//  Client.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/14/24.
//

import Firebase
import SwiftUI

@Observable
class ViewModel {
    private let locationService: LocationService
    
    init(locationService: LocationService = LocationService.shared) {
        self.locationService = locationService
    }
    
    var locations: [OldLocation] = []
    var count = 0
    
    func fetchAllLocations() async throws {
        do {
            count = try await locationService.fetchAllLocations()
        } catch {
            print("DEBUG: error fetching all locations: \(error.localizedDescription)")
        }
    }
}
