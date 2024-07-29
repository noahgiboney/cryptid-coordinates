//
//  UserModel.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/15/24.
//

import AuthenticationServices
import CryptoKit
import Firebase
import SwiftUI

@Observable
class AuthModel {
    private let userService: UserService
    
    var userSession: Firebase.User? {
        didSet {
            if userSession != nil {
                Task { try await fetchCurrentUser() }
            }
        }
    }
    
    var currentUser: User?
    
    init(userService: UserService = UserService.shared) {
        self.userService = userService
        updateUserSession()
        verifySignInWithAppleID()
    }
    
    func updateUserSession() {
        userSession = Auth.auth().currentUser
    }
}

// MARK: Firebase User
extension AuthModel {
    func fetchCurrentUser() async throws {
        do {
            currentUser = try await userService.fetchCurrentUser()
        } catch {
            print("")
        }
    }
    
    func createNewUser(id: String, name: String) async throws {
        do {
            try await userService.createNewUser(id: id, name: name)
        } catch {
            print("DEBUG: error creating user: \(error.localizedDescription)")
        }
    }
    
    func checkIfUserExists(userId: String) async throws -> Bool {
        return try await userService.checkIfUserExists(userId: userId)
    }
    
    func signOut() throws {
        do {
            try Auth.auth().signOut()
        } catch {
            print("FirebaseAuthError: signOut() failed. \(error)")
        }
        userSession = nil
        currentUser = nil
    }
    
    func deleteAccount() async throws{
        do {
            try await userService.deleteCurrentUser()
        } catch {
            print("FirebaseAuthError: deleteAccount() failed. \(error)")
        }
        userSession = nil
        currentUser = nil
    }
}

// MARK: Apple Authentication
extension AuthModel {
    func verifySignInWithAppleID() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let providerData = Auth.auth().currentUser?.providerData
        if let appleProviderData = providerData?.first(where: { $0.providerID == "apple.com" }) {
            Task {
                let credentialState = try await appleIDProvider.credentialState(forUserID: appleProviderData.uid)
                switch credentialState {
                case .authorized:
                    break
                case .revoked:
                    try signOut()
                case .notFound:
                    try await userService.deleteCurrentUser()
                    try signOut()
                default:
                    break
                }
            }
        }
    }
    
    func appleAuth(
        _ appleIDCredential: ASAuthorizationAppleIDCredential,
        nonce: String?
    ) async throws -> AuthDataResult? {
        guard let nonce = nonce else {
            fatalError("Invalid state: A login callback was received, but no login request was sent.")
        }
        
        guard let appleIDToken = appleIDCredential.identityToken else {
            print("Unable to fetch identity token")
            return nil
        }
        
        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
            return nil
        }
        
        let credentials = OAuthProvider.appleCredential(withIDToken: idTokenString,
                                                        rawNonce: nonce,
                                                        fullName: appleIDCredential.fullName)
        
        do {
            return try await Auth.auth().signIn(with: credentials)
        }
        catch {
            print("FirebaseAuthError: appleAuth(appleIDCredential:nonce:) failed. \(error)")
            throw error
        }
    }
}

extension ASAuthorizationAppleIDCredential {
    func displayName() -> String {
        return [self.fullName?.givenName, self.fullName?.familyName]
            .compactMap( {$0})
            .joined(separator: " ")
    }
}

