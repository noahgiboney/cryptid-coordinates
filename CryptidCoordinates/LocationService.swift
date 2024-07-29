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
    
//    private let locationRef = Firestore.firestore().collection("locations")
//    
//    func fetchLocation(id: String) async throws -> Location {
//        return try await locationRef.document(id).getDocument(as: Location.self)
//    }
//    
//    func submitRequest(location: LocationRequest) async throws {
//        let encodedLocation = try Firestore.Encoder().encode(location)
//        try await Firestore.firestore().collection("locationRequests").document(location.locationName).setData(encodedLocation)
//    }
}

// MARK: - trending

extension LocationService {
    func fetchTrending() async throws -> [String] {
        let trendingRef = Firestore.firestore().collection("trending")
        let snapshot = try await trendingRef.getDocuments()
        return snapshot.documents.compactMap { $0.documentID }
    }
}

// MARK: - nearest locations
extension LocationService {
//    func fetchNearestLocations(for userCords: CLLocationCoordinate2D) async throws -> [Location] {
//        let geohashes = geohashNeighbors(cords: userCords)
//        
//        let snapshot = try await locationRef.whereField("geohash", in: geohashes).getDocuments()
//        
//        nearestLocations = snapshot.documents.compactMap( { try? $0.data(as: Location.self) })
//        
//        // check if user saved post
//        await withThrowingTaskGroup(of: Void.self) { groupTask in
//            for location in nearestLocations {
//                groupTask.addTask {
//                    let didSave = try await self.didSave(locationId: location.id)
//                    await MainActor.run {
//                        self.updateDidSave(didSave: didSave, id: location.id)
//                    }
//                }
//            }
//        }
//        print(nearestLocations.count)
//        // sort by closest location
//        let sortedLocations = nearestLocations.sorted { location1, location2 in
//            let distance1 = userCords.distance(from: CLLocation(latitude: location1.latitude, longitude: location1.longitude))
//            let distance2 = userCords.distance(from: CLLocation(latitude: location2.latitude, longitude: location2.longitude))
//            
//            return distance1 < distance2
//        }
//        
//        return Array(sortedLocations.prefix(50))
//    }
//    
//    private func geohashNeighbors(cords: CLLocationCoordinate2D) -> [Geohash.Hash] {
//        let geohash = Geohash(coordinates: (cords.latitude, cords.longitude), precision: 4)
//        
//        guard let currentGeohash = geohash?.geohash else { return [] }
//        guard var neighbors = geohash?.neighbors?.all.compactMap( { $0.geohash }) else { return [] }
//        neighbors.append(currentGeohash)
//        
//        return neighbors
//    }
//    
//    private func updateDidSave(didSave: Bool, id: String) {
//        if let index = nearestLocations.firstIndex(where: { $0.id == id }) {
//            nearestLocations[index].didSave = didSave
//        }
//    }
}

// MARK: - saves
extension LocationService {
    private func savedCollection(_ userId: String) -> CollectionReference {
        return Firestore.firestore().collection("saves").document(userId).collection("saves")
    }
    
//    func fetchedSaved() async throws -> [Location] {
//        try await withThrowingTaskGroup(of: Location.self) { taskGroup in
//            
//            guard let user = Auth.auth().currentUser else { return [] }
//            let snapshot = try await savedCollection(user.uid).getDocuments()
//            
//            var locations: [Location] = []
//            for doc in snapshot.documents {
//                taskGroup.addTask {
//                    try await self.fetchLocation(id: doc.documentID)
//                }
//            }
//            
//            for try await var location in taskGroup {
//                location.didSave = true
//                locations.append(location)
//            }
//            
//            return locations
//        }
//    }
    
    func save(locationId: String) async throws {
        guard let user = Auth.auth().currentUser else { return }
        try await savedCollection(user.uid).document(locationId).setData([:])
    }
    
    func unsave(locationId: String) async throws {
        guard let user = Auth.auth().currentUser else { return }
        try await savedCollection(user.uid).document(locationId).delete()
    }
    
    func didSave(locationId: String) async throws -> Bool {
        guard let user = Auth.auth().currentUser else { return false }
        return try await savedCollection(user.uid).document(locationId).getDocument().exists
    }
}
