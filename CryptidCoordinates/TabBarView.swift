//
//  TabBarView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/12/24.
//

import SwiftUI

struct TabBarView: View {
    var currentUser: User
    @State private var viewModel: ViewModel
    
    init(currentUser: User) {
        self.currentUser = currentUser
        let viewModel = ViewModel(user: currentUser)
        self._viewModel = State(initialValue: viewModel)
    }
    
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
            
            LeaderboardView()
                .tabItem {
                    VStack {
                        Image(systemName: "medal")
                        Text("Leadboard")
                    }
                }
                .tag(2)
            
            ProfileView()
                .tabItem {
                    VStack {
                        Image(systemName: "person")
                        Text("Profile")
                    }
                }
                .tag(3)
        }
        .environment(viewModel)
    }
}

#Preview {
    TabBarView(currentUser: .example)
}
