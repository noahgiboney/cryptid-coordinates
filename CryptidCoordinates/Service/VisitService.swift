//
//  VisitService.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 7/14/24.
//

import Firebase
import Foundation

class VisitService {
    static let shared = VisitService()
    
    private init () {}
    
    private func vistRef(userId: String) -> CollectionReference {
        return Firestore.firestore().collection("visits").document(userId).collection("visits")
    }
    
    func fetchLeaderboard() async throws -> [User] {
        let snapshot = try await Firestore.firestore().collection("users")
            .order(by: "visits", descending: true)
            .limit(to: 10)
            .getDocuments()
        
        return snapshot.documents.compactMap { try? $0.data(as: User.self)}
    }
    
    func checkDidVisist(userId: String, locationId: String) async throws -> Bool {
        let document = try await vistRef(userId: userId).document(locationId).getDocument()
        return document.exists
    }
    
    func logVisit(visit: Visit, visitCount: Int) async throws {
        let encodedVisit = try Firestore.Encoder().encode(visit)
        try await vistRef(userId: visit.userId).document(visit.locationId).setData(encodedVisit)
        try await UserService.shared.updateUser(field: "visits", value: visitCount)
    }
    
    func fetchVisits(userId: String) async throws -> [Visit] {
        let snapshot = try await vistRef(userId: userId).order(by: "timestamp", descending: true).getDocuments()
        return snapshot.documents.compactMap( { try? $0.data(as: Visit.self) })
    }
}
