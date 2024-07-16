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
    
    private init () {}
    
    private let locationRef = Firestore.firestore().collection("locations")
    
    func fetchLocation(id: String) async throws -> Location {
        return try await locationRef.document(id).getDocument(as: Location.self)
    }
    
    func submitRequest(location: LocationRequest) async throws {
        let encodedLocation = try Firestore.Encoder().encode(location)
        try await Firestore.firestore().collection("locationRequests").document(location.locationName).setData(encodedLocation)
    }
    
    // fetch all locations in current and neighboring geohashes
    func fetchNearestLocations(for userCords: CLLocationCoordinate2D) async throws -> [Location] {
        let geohash = Geohash(coordinates: (userCords.latitude, userCords.longitude), precision: 4)
        
        guard let currentGeohash = geohash?.geohash else { return [] }
        guard var neighbors = geohash?.neighbors?.all.compactMap( { $0.geohash }) else { return [] }
        neighbors.append(currentGeohash)
        
        let snapshot = try await locationRef.whereField("geohash", in: neighbors).getDocuments()
        
        let locations = snapshot.documents.compactMap( { try? $0.data(as: Location.self) })
        
        return locations.sorted { location1, location2 in
            let distance1 = userCords.distance(from: CLLocation(latitude: location1.latitude, longitude: location1.longitude))
            let distance2 = userCords.distance(from: CLLocation(latitude: location2.latitude, longitude: location2.longitude))
            
            return distance1 < distance2
        }
    }
}

// MARK: - saves
extension LocationService {
    private func savedCollection(_ userId: String) -> CollectionReference {
        return Firestore.firestore().collection("saves").document(userId).collection("saves")
    }
    
    func fetchedSaved() async throws -> [Location] {
        try await withThrowingTaskGroup(of: Location.self) { taskGroup in
            
            guard let user = Auth.auth().currentUser else { return [] }
            let snapshot = try await savedCollection(user.uid).getDocuments()
            
            var locations: [Location] = []
            for doc in snapshot.documents {
                taskGroup.addTask {
                    try await self.fetchLocation(id: doc.documentID)
                }
            }
            
            for try await location in taskGroup {
                locations.append(location)
            }
            
            return locations
        }
    }
    
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
