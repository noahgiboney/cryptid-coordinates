//
//  VisitsStore.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 9/5/24.
//

import CoreLocation
import Firebase
import Foundation

@Observable
class VisitStore {
    
    var userVisits: [Location : Timestamp] = [:]
    
    func mapCurrentUserVists(locations: [Location], visits: [Visit]) {
        userVisits = mapVisits(locations: locations, visits: visits)
    }
    
    func fetchVisits(for userId: String) async throws -> [Visit] {
        return try await FirebaseService.shared.fetchData(ref: Collections.userVists(for: userId))
    }
    
    func mapVisits(locations: [Location], visits: [Visit]) -> [Location : Timestamp] {
        var dict: [Location : Timestamp] = [:]
        
        for visit in visits {
            if let index = locations.firstIndex(where: { $0.id == visit.locationId } ) {
                dict[locations[index]] = visit.timestamp
            }
        }
        return dict
    }
    
    func logVisit(locationId: String, newVisitCount: Int) async throws {
        guard let user = Auth.auth().currentUser else { return }
        
        let newVisit = Visit(id: locationId, userId: user.uid, locationId: locationId)
        
        async let result1: Void = try await FirebaseService.shared.setData(object: newVisit, ref: Collections.userVists(for: user.uid))
        
        async let result2: Void = try await FirebaseService.shared.updateDataField(id: user.uid, field: "visits", value: newVisitCount, ref: Collections.users)
        
        _ = try await (result1, result2)
    }
    
    func checkDidVisit(cords: CLLocationCoordinate2D, location: Location) async -> VisitState {
        guard let user = Auth.auth().currentUser else { return .alreadyVisited }
    
        do {
            print(location.id)
            async let alreadyVisited = Collections.userVists(for: user.uid).document(location.id).getDocument().exists
            
            async let scanning: Void = Task.sleep(nanoseconds: 1_500_000_000)
            
            let delay = try await (alreadyVisited, scanning)
            
            if delay.0 {
                return .alreadyVisited
            }
            
            /// 0.3 miles 483
            let minDistance = 483.0
            
            let distanceFromLocation = cords.distance(from: location.clLocation)

            if distanceFromLocation <= minDistance {
                return .newVisit
            } else {
                return .notInProximity
            }
        } catch {
            print("Error: checkDidVisit(): \(error.localizedDescription)")
        }
        return .alreadyVisited
    }
}
