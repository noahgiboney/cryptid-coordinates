//
//  ViewModel.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/14/24.
//

import Firebase
import SwiftUI

@Observable
class ViewModel {
    private let locationService: FirebaseService
    var user: User
    
    init(locationService: FirebaseService = FirebaseService.shared, user: User) {
        self.locationService = locationService
        self.user = user
    }
    
    var locations: [OldLocation] = []
    var count = 0
    var tabSelection = 0
    
    func fetchAllLocations() async throws {
        do {
            count = try await locationService.fetchAllLocations()
        } catch {
            print("DEBUG: error fetching all locations: \(error.localizedDescription)")
        }
    }
}
