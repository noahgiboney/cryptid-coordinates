//
//  LandingView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/14/24.
//

import AuthenticationServices
import Firebase
import KeychainSwift
import SwiftUI

struct LandingView: View {
    @Environment(AuthModel.self) var authModel
    @State private var errorMessage = ""
    @State private var isShowingError = false
    @State var colors: [(id: Int, color: UIColor, frequency: CGFloat)] = []
    @State var gradietnModel = AnimatedGradient.Model(colors: [.accent, .backgroundGray])
    
    var body: some View {
        GradientEffectView($gradietnModel)
            .ignoresSafeArea()
            .overlay(alignment: .center) {
                VStack(spacing: 20) {
                    Image(.icon)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                    Text("Cryptid Coordinates")
                        .font(.title.bold())
                        .foregroundStyle(.white)
                    Text("Uncover what lurks in the shadows")
                        .font(.headline)
                        .foregroundStyle(.white)
                }
            }
            .foregroundStyle(.black)
            .overlay(alignment: .bottom) {
                SignInWithAppleButton { request in
                    AppleAuthManager.shared.requestAppleAuthorization(request)
                } onCompletion: { result in
                    handleAppleID(result)
                }
                .clipShape(Capsule())
                .frame(height: 50)
                .padding(.horizontal, 20)
            }
            .alert(errorMessage, isPresented: $isShowingError) { }
    }
    
    func handleAppleID(_ result: Result<ASAuthorization, Error>) {
        if case let .success(auth) = result {
            guard let appleIDCredentials = auth.credential as? ASAuthorizationAppleIDCredential else {
                print("AppleAuthorization failed: AppleID credential not available")
                return
            }
            
            Task {
                do {
                    let result = try await authModel.appleAuth(
                        appleIDCredentials,
                        nonce: AppleAuthManager.nonce
                    )
                    if let result = result {
                        let keychain = KeychainSwift()
                        let id = result.user.uid
                        
                        // check if user has an active account
                        let accountExists = try await authModel.checkIfUserExists(userId: id)
                        
                        if !accountExists {
                            var displayName: String
                            
                            // if user had a account previously, use name saved in keychain
                            if let name = keychain.get("displayName") {
                                displayName = name
                            } else {
                                // otherwise, use apple id, save display name to keychain
                                displayName = appleIDCredentials.displayName()
                                keychain.set(displayName, forKey: "displayName")
                            }
                                
                            // create the user
                            try await authModel.createNewUser(id: id, name: displayName)
                        }
                        
                        // set the session
                        authModel.userSession = result.user
                    }
                } catch {
                    print("AppleAuthorization failed: \(error)")
                }
            }
        }
        else if case let .failure(error) = result {
            print("AppleAuthorization failed: \(error)")
        }
    }
}

#Preview {
    LandingView()
        .preferredColorScheme(.dark)
        .environment(AuthModel())
}
