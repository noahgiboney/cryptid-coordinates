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
    @State private var userModel = UserModel()
    
    var body: some View {
        Group {
            if userModel.userSession != nil {
                TabBarView()
            } else {
                LandingView()
            }
        }
        .environment(userModel)
    }
}

#Preview {
    ContentView()
}
