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
    
    var locations: [Location] = []
    
    func fetchAllLocations() async throws {
        do {
            locations = try await client.fetchAllLocations()
        } catch {
            print("DEBUG: error fetching all locations: \(error.localizedDescription)")
        }
    }
}
