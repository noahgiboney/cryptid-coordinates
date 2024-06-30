//
//  ContentView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/12/24.
//

import FirebaseFirestore
import FirebaseCore
import SwiftUI

struct ContentView: View {
    @State private var userViewModel = UserModel()
    
    var body: some View {
        Group {
            if userViewModel.userSession != nil,
               let user = userViewModel.currentUser {
                TabBarView(currentUser: user)
                
            } else {
                LandingView()
            }
        }
        .environment(userViewModel)
    }
}

#Preview {
    ContentView()
}
