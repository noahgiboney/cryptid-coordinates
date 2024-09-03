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
    
    func fetchVisits(userId: String) async throws -> [Visit] {
        let snapshot = try await vistRef(userId: userId).order(by: "timestamp", descending: true).getDocuments()
        return snapshot.documents.compactMap( { try? $0.data(as: Visit.self) })
    }
    
//    func deleteVisits(for userId: String) async throws {
//        let snapshot = try await vistRef(userId: userId).getDocuments()
//        for doc in snapshot.documents {
//            try await doc.reference.delete()
//        }
//    }
}
