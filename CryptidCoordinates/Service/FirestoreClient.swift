//
//  FirestoreClient.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/14/24.
//

import Firebase
import Foundation

class FirestoreClient {
    private let db = Firestore.firestore()
    
    func fetchAllLocations() async throws -> [Location] {
        let snapshot = try await db.collection("location").getDocuments()
        return snapshot.documents.compactMap({ try? $0.data(as: Location.self) })
    }
}
