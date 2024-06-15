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
    @Environment(\.colorScheme) var colorScheme
    
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
                SignInWithAppleButton(.continue) { request in
                    request.requestedScopes = [.fullName]
                } onCompletion: { result in
                    //                switch result {
                    //                case .success(let authorization):
                    //                    print("Hello")
                    //                case .failure(let error):
                    //                    print("Hello")
                    //                }
                }
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .shadow(color: Color.white.opacity(0.25), radius: 10)
                .frame(height: 50)
                .padding(.horizontal, 20)
                
                Text("Or")
                    .font(.footnote)
                
                Button("Continue without an account") {
                    
                }
                .foregroundStyle(Color.primary)
            }
        }
    }
    
    //    func firebaseSignIn(_ authorization: ASAuthorization) async throws {
    //        let result = Auth.auth().signIn(with: authorization)
    //    }
    
    func signInAnon() {
        Auth.auth().signInAnonymously { result, error in
            
        }
    }
}

#Preview {
    LandingView()
        .preferredColorScheme(.light)
}
