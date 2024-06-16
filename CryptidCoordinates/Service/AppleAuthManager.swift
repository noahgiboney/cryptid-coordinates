//
//  AppleSignInCoordinator.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/15/24.
//

import AuthenticationServices
import CryptoKit
import SwiftUI

class AppleAuthManager {
    static let shared = AppleAuthManager()
    
    fileprivate static var currentNonce: String?
    
    static var nonce: String? {
        currentNonce ?? nil
    }
    
    private init() {}
    
    func requestAppleAuthorization(_ request: ASAuthorizationAppleIDRequest) {
        AppleAuthManager.currentNonce = randomNonceString()
        request.requestedScopes = [.fullName]
        request.nonce = sha256(AppleAuthManager.currentNonce!)
    }
}

extension AppleAuthManager {
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError(
                "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
        }
        
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        
        let nonce = randomBytes.map { byte in
            // Pick a random character from the set, wrapping around if needed.
            charset[Int(byte) % charset.count]
        }
        
        return String(nonce)
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
}

