//
//  TabBarView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/12/24.
//

import SwiftUI

struct TabBarView: View {
    var currentUser: User
    @State private var global: GlobalModel
    
    init(currentUser: User) {
        self.currentUser = currentUser
        let global = GlobalModel(user: currentUser)
        self._global = State(initialValue: global)
    }
    
    var body: some View {
        TabView(selection: $global.tabSelection) {
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
        .environment(global)
    }
}

#Preview {
    TabBarView(currentUser: .example)
}
