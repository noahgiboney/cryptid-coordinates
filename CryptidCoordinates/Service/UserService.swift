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
    
    private let userRef = Firestore.firestore().collection("users")
    
    func fetchCurrentUser() async throws -> User? {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return nil }
        return try await userRef.document(currentUserId).getDocument(as: User.self)
    }
    
    func fetchUser(userId: String) async throws -> User {
        return try await userRef.document(userId).getDocument(as: User.self)
    }
    
    func createNewUser(id: String, name: String) async throws {
        let newUser = User(id: id, name: name)
        let encodedUser = try Firestore.Encoder().encode(newUser)
        try await userRef.document(id).setData(encodedUser)
    }
    
    func deleteCurrentUser() async throws {
        guard let user = Auth.auth().currentUser else { return }
        try await userRef.document(user.uid).delete()
        try await user.delete()
    }
    
    func updateUser(field: String, value: Any) async throws {
        guard let user = Auth.auth().currentUser else { return }
        try await userRef.document(user.uid).updateData([field: value])
    }
    
    func checkIfUserExists(userId: String) async throws -> Bool {
        return try await userRef.document(userId).getDocument().exists
    }
}
