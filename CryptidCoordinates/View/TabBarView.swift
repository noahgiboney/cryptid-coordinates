//
//  TabBarView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/12/24.
//

import MapKit
import SwiftUI

struct TabBarView: View {
    var currentUser: User
    @State private var global: GlobalModel
    @StateObject private var locationManager = LocationManager()
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
                        Image(systemName: "house")
                        Text("Explore")
                    }
                }
                .tag(0)
            
            MapView(defaultCords: locationManager.lastKnownLocation ?? CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194))
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
        .environment(saved)
        .environmentObject(locationManager)
    }
}

#Preview {
    TabBarView(currentUser: .example)
}
