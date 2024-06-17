//
//  ProfileView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/15/24.
//

import SwiftUI

struct ProfileView: View {
    @Environment(UserViewModel.self) var userModel
    
    var body: some View {
        Group {
            if let user = userModel.currentUser {
                NavigationStack {
                    VStack {
                        Button("Sign Out") {
                            try? userModel.signOut()
                        }
                    }
                    .navigationTitle(user.name)
                }
            }
        }
    }
}

#Preview {
    ProfileView()
        .environment(UserViewModel())
}
