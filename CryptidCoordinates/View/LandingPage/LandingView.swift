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
    @Environment(AuthModel.self) var authModel
    @Environment(\.colorScheme) var colorScheme
    @State private var errorMessage = ""
    @State private var isShowingError = false
    
    private var darkModeColors: [Color] {
        [Color("AccentColor"), Color.black]
    }
    
    private var lightModeColors: [Color] {
        [ Color("AccentColor"), Color.white]
    }
    @State var colors: [(id: Int, color: UIColor, frequency: CGFloat)] = []
    @State var gradietnModel = AnimatedGradient.Model(colors: [])
    
    var body: some View {
        GradientEffectView($gradietnModel)
            .ignoresSafeArea()
            .onAppear {
                gradietnModel.colors = colorScheme == .dark ? darkModeColors : lightModeColors
            }
            .overlay(alignment: .center) {
                VStack(spacing: 20) {
                    Image(.nun)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                    Text("Cryptid Coordinates")
                        .font(.title.bold())
                    Text("Uncover what lurks in the shadows.")
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
                        let id = result.user.uid
                        let accountExists = try await authModel.checkIfUserExists(userId: id)
                        
                        if !accountExists {
                            try await authModel.createNewUser(id: id, name: appleIDCredentials.displayName())
                        }
                        
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
