//
//  TabBarView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/12/24.
//

import SwiftUI

struct TabBarView: View {
    @State private var viewModel = ViewModel()
    @State private var selection = 0
    
    var body: some View {
        TabView(selection: $selection) {
            HomeView()
                .tabItem {
                    VStack {
                        Image(systemName: "house")
                        Text("Home")
                    }
                }
                .tag(0)
            
            MapView()
                .tabItem {
                    VStack {
                        Image(systemName: "map")
                        Text("Map")
                    }
                }
                .tag(1)
            
            ProfileView()
                .tabItem {
                    VStack {
                        Image(systemName: "person")
                        Text("Profile")
                    }
                }
                .tag(2)
        }
        .environment(viewModel)
    }
}

#Preview {
    TabBarView()
}
