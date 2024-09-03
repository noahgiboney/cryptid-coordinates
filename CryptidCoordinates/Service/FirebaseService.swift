//
//  FirebaseService.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 9/2/24.
//

import Firebase
import Foundation

struct FirebaseService {
    
    static let shared = FirebaseService()
    
    func fetchOne<T: DataModel>(id: String, ref: CollectionReference) async throws -> T? {
        let snapshot = try await ref.document(id).getDocument()
        return try snapshot.data(as: T.self)
    }
    
    func fetchData<T: DataModel>(ref: CollectionReference, id: String? = nil) async throws -> [T] {
        let snapshot = try await ref.getDocuments()
        return snapshot.documents.compactMap { try? $0.data(as: T.self) }
    }
    
    func setData<T:DataModel>(object: T, ref: CollectionReference) async throws {
        guard let id = object.id as? String else { return }
        
        let data = try Firestore.Encoder().encode(object)
        try await ref.document(id).setData(data)
    }
    
    func delete(id: String, ref: CollectionReference) {
        ref.document(id).delete()
    }
    
    func deleteCollection(ref: CollectionReference) async throws {
        let snaphot = try await ref.getDocuments()
        
        try await withThrowingTaskGroup(of: Void.self) { group in
            for doc in snaphot.documents {
                try await doc.reference.delete()
            }
        }
    }
    
    func updateData<T: DataModel>(object: T, ref: CollectionReference) async throws {
        guard let id = object.id as? String else { return }
        
        let data = try Firestore.Encoder().encode(object)
        try await ref.document(id).updateData(data)
    }
    
    func updateDataField(id: String, field: String, value: Any, ref: CollectionReference) async throws {
        try await ref.document(id).updateData([field: value])
    }
}
