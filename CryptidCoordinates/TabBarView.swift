//
//  TabBarView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/12/24.
//

import SwiftUI

struct TabBarView: View {
    @State private var viewModel = ViewModel()
    
    var body: some View {
        TabView(selection: $viewModel.tabSelection) {
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
