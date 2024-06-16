//
//  UserManager.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/15/24.
//

import CryptoKit
import Firebase
import AuthenticationServices
import SwiftUI

@Observable
class UserModel {
    private let userService: UserService
    
    var userSession: Firebase.User? {
        didSet {
            Task { try await fetchCurrentUser() }
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

// MARK: Firebase
extension UserModel {
    func fetchCurrentUser() async throws {
        do {
            currentUser = try await userService.fetchCurrentUser()
        } catch {
            print("")
        }
    }
    
    func createNewUser(id: String, name: String) async throws {
        do {
            try await UserService.shared.createNewUser(id: id, name: name)
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
}

// MARK: Apple Authentication
extension UserModel {
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
                    if let userId = Auth.auth().currentUser?.uid {
                        userService.deleteUser(userId: userId)
                        try signOut()
                    }
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

