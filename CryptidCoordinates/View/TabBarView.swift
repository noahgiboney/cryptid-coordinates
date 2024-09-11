//
//  TabBarView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/12/24.
//

import MapKit
import SwiftUI

struct TabBarView: View {
    
    let currentUser: User
    @StateObject private var locationManager = LocationManager()
    @State private var global: Global
    @State private var saved = Saved()
    @State private var visitStore = VisitStore()
    @State private var locations = LocationStore()
    
    init(currentUser: User) {
        print("init")
        self.currentUser = currentUser
        self._global = State(initialValue: Global(user: currentUser, defaultCords: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)))
    }
    
    var body: some View {
        TabView(selection: $global.tabSelection) {
            ExploreScreen()
                .tabItem {
                    Image(systemName: "house")
                }
                .tag(0)
            
            MapScreen(defaultCords: CLLocationCoordinate2D(latitude: 0, longitude: 0))
                .tabItem {
                    Image(systemName: "map")
                }
                .tag(1)
            
            LeaderboardScreen()
                .tabItem {
                    Image(systemName: "medal")
                }
                .tag(2)
            
            ProfileScreen()
                .tabItem {
                    Image(systemName: "person")
                }
                .tag(3)
        }
        .environmentObject(locationManager)
        .environment(global)
        .environment(saved)
        .environment(visitStore)
        .environment(locations)
        .onAppear {
            locationManager.start()
        }
    }
}

#Preview {
    TabBarView(currentUser: .example)
}
