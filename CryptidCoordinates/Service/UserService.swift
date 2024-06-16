//
//  UserService.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/15/24.
//

import Firebase
import FirebaseAuth
import Foundation

class UserService {
    static let shared = UserService()
    
    private init() {}
    
    private let db = Firestore.firestore().collection("users")
    
    func fetchCurrentUser() async throws -> User? {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return nil }
        return try await db.document(currentUserId).getDocument(as: User.self)
    }
    
    func createNewUser(id: String, name: String) async throws {
        let newUser = User(id: id, name: name)
        let encodedUser = try Firestore.Encoder().encode(newUser)
        try await db.document(id).setData(encodedUser)
    }
    
    func deleteUser(userId: String) {
        db.document(userId).delete()
    }
    
    func checkIfUserExists(userId: String) async throws -> Bool {
        return try await db.document(userId).getDocument().exists
    }
}
