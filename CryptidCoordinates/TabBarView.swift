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
    @StateObject private var locationManager = LocationManager()
    @State private var store = LocationStore()
    @State private var saved = Saved()
    
    init(currentUser: User) {
        self.currentUser = currentUser
        let global = GlobalModel(user: currentUser)
        self._global = State(initialValue: global)
    }
    
    var body: some View {
        TabView(selection: $global.tabSelection) {
            ExploreView()
                .tabItem {
                    VStack {
                        Image(systemName: "eye")
                        Text("Explore")
                    }
                }
                .tag(0)
            
            MapContainerView()
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
                        Image(systemName: "point.3.filled.connected.trianglepath.dotted")
                        Text("Leaderboard")
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
        .onAppear {
            locationManager.start()
        }
        .environment(global)
        .environment(store)
        .environment(saved)
        .environmentObject(locationManager)
    }
}

#Preview {
    TabBarView(currentUser: .example)
}
