//
//  FirestoreClient.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/14/24.
//

import Firebase
import FirebaseCore
import Foundation

class FirebaseService {
    static let shared = FirebaseService()
    
    private init () {}
    
    private let db = Firestore.firestore()
    
    func fetchAllLocations() async throws -> Int {
        let snapshot = try await Firestore.firestore().collection("locations").getDocuments()
        return snapshot.documents.count
    }
    
    func submitRequest(location: LocationRequest) async throws {
        let encodedLocation = try Firestore.Encoder().encode(location)
        try await Firestore.firestore().collection("locationRequests").document(location.locationName).setData(encodedLocation)
    }
}
