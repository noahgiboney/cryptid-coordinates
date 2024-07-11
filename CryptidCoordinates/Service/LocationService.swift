//
//  LocationService.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 7/10/24.
//

import Firebase
import Foundation

class LocationService {
    static let shared = LocationService()
    private let postRef = Firestore.firestore().collection("locations")
    
    private init () {}
    
    func fetchRandomLocation() async throws -> Location? {
        let random = UUID().uuidString
        
        let snapshot = try await postRef.whereField("id", isGreaterThan: UUID().uuidString).order(by: "id", descending: true).limit(to: 1).getDocuments()
        
        let locations = snapshot.documents.compactMap({ try? $0.data(as: Location.self)})
        
        guard let location = locations.first else { return nil }
        return location
    }
}
