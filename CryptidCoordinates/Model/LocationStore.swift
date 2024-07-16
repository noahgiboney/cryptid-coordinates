//
//  ExploreModel.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 7/10/24.
//

import CoreLocation
import Firebase
import Foundation

@Observable
class LocationStore {
    var nearLocations: [Location] = []
    var savedLocations: [Location] = []
    var didLoadNearLocations = false
    
    func fetchNearLocations(userCords: CLLocationCoordinate2D) async throws {
        do {
            nearLocations = try await LocationService.shared.fetchNearestLocations(for: userCords)
            didLoadNearLocations = true
        } catch {
            print("ERROR: \(error.localizedDescription)")
        }
    }
}

// MARK: - visits
extension LocationStore {
    func logVisit(locationId: String) async throws {
        guard let user = Auth.auth().currentUser else { return}
        let newVisit = Visit(userId: user.uid, locationId: locationId)
        
        do {
            try await VisitService.shared.logVisit(visit: newVisit)
        } catch {
            print("Error: logVisit() : \(error.localizedDescription)")
        }
    }
}


// MARK: - saves
extension LocationStore {
    func fetchSaved() async throws {
        do {
            savedLocations = try await LocationService.shared.fetchedSaved()
        } catch {
            print("Error: fetchSaved() : \(error.localizedDescription)")
        }
    }
    
    func save(locationId id: String) async throws {
        do {
            try await LocationService.shared.save(locationId: id)
        } catch {
            print("Error: save() : \(error.localizedDescription)")
        }
    }
    
    func unsave(locationId id: String) async throws {
        do {
            try await LocationService.shared.unsave(locationId: id)
        } catch {
            print("Error: unsave() : \(error.localizedDescription)")
        }
    }
}
