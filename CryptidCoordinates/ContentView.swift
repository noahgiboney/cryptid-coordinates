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
    @State private var userViewModel = UserViewModel()
    
    var body: some View {
        Group {
            if userViewModel.userSession != nil {
                TabBarView()
                
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
