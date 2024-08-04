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
    var defaultCords: CLLocationCoordinate2D
    @State private var global: GlobalModel
    @State private var saved = Saved()
    
    init(currentUser: User, defaultCords: CLLocationCoordinate2D) {
        self.currentUser = currentUser
        self.defaultCords = defaultCords
        let global = GlobalModel(user: currentUser, defaultCords: defaultCords)
        self._global = State(initialValue: global)
    }
    
    var body: some View {
        TabView(selection: $global.tabSelection) {
            ExploreView()
                .tabItem {
                    Image(systemName: "house")
                }
                .tag(0)
            
            MapView(defaultCords: defaultCords)
                .tabItem {
                    Image(systemName: "map")
                }
                .tag(1)
            
            LeaderboardView()
                .tabItem {
                    Image(systemName: "medal")
                }
                .tag(2)
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person")
                }
                .tag(3)
        }
        .environment(global)
        .environment(saved)
    }
}

#Preview {
    TabBarView(currentUser: .example, defaultCords: Location.example.coordinates)
}
