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
    private let client: FirestoreClient
    
    init(client: FirestoreClient) {
        self.client = client
    }
    
    var locations: [OldLocation] = []
    var count = 0
    
    func fetchAllLocations() async throws {
        do {
            count = try await client.fetchAllLocations()
        } catch {
            print("DEBUG: error fetching all locations: \(error.localizedDescription)")
        }
    }
}
