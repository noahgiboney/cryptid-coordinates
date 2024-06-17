//
//  LandingView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/14/24.
//

import AuthenticationServices
import Firebase
import SwiftUI

struct LandingView: View {
    @Environment(UserViewModel.self) var userViewModel
    @Environment(\.colorScheme) var colorScheme

    @State private var errorMessage = ""
    @State private var isShowingError = false
    
    private var darkModeColors: [Color] {
        [Color.red, Color.black.opacity(0.8)]
    }
    
    private var lightModeColors: [Color] {
        [Color.red, Color.white.opacity(0.8)]
    }
    
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: colorScheme == .dark ? darkModeColors : lightModeColors),
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea(.all)
        .overlay(alignment: .center) {
            VStack(spacing: 20){
                Text("Cryptid Coordinates")
                    .font(.title.bold())
                Text("Discover the Haunt, Share the Thrill")
            }
        }
        .overlay(alignment: .bottom) {
            VStack(spacing: 10) {
                SignInWithAppleButton { request in
                    AppleAuthManager.shared.requestAppleAuthorization(request)
                } onCompletion: { result in
                    handleAppleID(result)
                }
                .overlay {
                    ZStack {
                        Capsule()
                        HStack {
                            Image(systemName: "applelogo")
                            Text("Continue with Apple")
                            
                        }
                        .foregroundStyle(colorScheme == .dark ? .black : .white)
                    }
                    .allowsHitTesting(false)
                }
                .clipShape(Capsule())
                .frame(height: 50)
                .padding(.horizontal, 20)
                    
                Text("Or")
                    .font(.footnote)
                
                Button("Continue without an account") {
                    
                }
                .foregroundStyle(Color.primary)
            }
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
                    let result = try await userViewModel.appleAuth(
                        appleIDCredentials,
                        nonce: AppleAuthManager.nonce
                    )
                    if let result = result {
                        let id = result.user.uid
                        let accountExists = try await userViewModel.checkIfUserExists(userId: id)
                        
                        if !accountExists {
                            try await userViewModel.createNewUser(id: id, name: appleIDCredentials.displayName())
                        }
                        
                        userViewModel.userSession = result.user
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
        .environment(UserViewModel())
}
