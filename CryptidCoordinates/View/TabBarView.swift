//
//  TabBarView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/12/24.
//

import MapKit
import SwiftUI

enum AppTab: CaseIterable, Identifiable {
    
    case explore, map, leaderboard, profile
    
    var systemImage: String {
        switch self {
        case .explore:
            "house"
        case .map:
            "map"
        case .leaderboard:
            "medal"
        case .profile:
            "person"
        }
    }
    
    var id: Self { self }
}

struct TabBarView: View {
    let currentUser: User
    @StateObject private var locationManager = LocationManager()
    @State private var global: Global
    @State private var saved = Saved()
    @State private var visitStore = VisitStore()
    @State private var locations = LocationStore()
    
    init(currentUser: User) {
        self.currentUser = currentUser
        self._global = State(initialValue: Global(user: currentUser, defaultCords: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)))
    }
    
    var body: some View {
        TabView(selection: $global.tabSelection) {
            ForEach(AppTab.allCases) { tab in
                tabView(for: tab)
                    .tabItem {
                        Image(systemName: tab.systemImage)
                    }
            }
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
    
    @ViewBuilder
    func tabView(for tab: AppTab) -> some View {
        switch tab {
        case .explore:
            ExploreScreen()
        case .map:
            MapScreen(defaultCords: CLLocationCoordinate2D(latitude: 0, longitude: 0))
        case .leaderboard:
            LeaderboardScreen()
        case .profile:
            ProfileScreen()
        }
    }
}

#Preview {
    TabBarView(currentUser: .example)
}
