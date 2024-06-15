//
//  TabBarView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/12/24.
//

import SwiftUI

struct TabBarView: View {
    @State private var viewModel = ViewModel(client: FirestoreClient())
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                }
            
            Text("Map")
                .tabItem {
                    Image(systemName: "map")
                }
            
            Text("Profile")
                .tabItem {
                    Image(systemName: "person")
                }
        }
        .environment(viewModel)
    }
}

#Preview {
    TabBarView()
}
