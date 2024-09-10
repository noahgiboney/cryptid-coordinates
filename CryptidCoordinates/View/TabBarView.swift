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
    let defaultCords: CLLocationCoordinate2D
    @State private var global: Global
    @State private var saved = Saved()
    @State private var visitStore = VisitStore()
    @State private var locations = LocationStore()
    
    init(currentUser: User, defaultCords: CLLocationCoordinate2D) {
        self.currentUser = currentUser
        self.defaultCords = defaultCords
        self._global = State(initialValue: Global(user: currentUser, defaultCords: defaultCords))
    }
    
    var body: some View {
        TabView(selection: $global.tabSelection) {
            ExploreScreen()
                .tabItem {
                    Image(systemName: "house")
                }
                .tag(0)
            
            MapScreen(defaultCords: defaultCords)
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
        .environment(global)
        .environment(saved)
        .environment(visitStore)
        .environment(locations)
    }
}

#Preview {
    TabBarView(currentUser: .example, defaultCords: Location.example.coordinates)
}
