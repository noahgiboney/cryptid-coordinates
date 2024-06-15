//
//  TabBarView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/12/24.
//

import SwiftUI

struct TabBarView: View {
    @State private var viewModel = ViewModel(client: FirestoreClient())
    @State private var selection = 0
    
    var body: some View {
        TabView(selection: $selection) {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                }
                .tag(0)
            
            MapView()
                .tabItem {
                    Image(systemName: "map")
                }
                .tag(1)
            
            Text("Profile")
                .tabItem {
                    Image(systemName: "person")
                }
                .tag(1)
        }
        .environment(viewModel)
    }
}

#Preview {
    TabBarView()
}
