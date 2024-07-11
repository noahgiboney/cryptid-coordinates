//
//  ExploreModel.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 7/10/24.
//

import Foundation

@Observable
class ExploreModel {
    var locations: [Location] = []
    var loadState: LoadState = .loading
    
    func populateLocations() async throws {
        do {
            try await withThrowingTaskGroup(of: Location?.self) { taskGroup in
                for _ in 0..<5 {
                    taskGroup.addTask {
                        return try await LocationService.shared.fetchRandomLocation()
                    }
                }
                
                
                for try await location in taskGroup {
                    if let location = location {
                        locations.append(location)
                    }
                }
            }
            loadState = .loaded
        } catch {
            loadState = .error
        }
    }
}
