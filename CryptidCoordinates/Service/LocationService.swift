//
//  FirestoreClient.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/14/24.
//

import Firebase
import Foundation

class LocationService {
    static let shared = LocationService()
    
    private init () {}
    
    private let db = Firestore.firestore()
    
    func fetchAllLocations() async throws -> Int {
        
        let snapshot = try await Firestore.firestore().collection("locations").getDocuments()
        return snapshot.documents.count
    }
}
