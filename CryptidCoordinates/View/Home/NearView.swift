//
//  NearbyView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 7/6/24.
//

import CoreLocationUI
import SwiftUI

struct NearView: View {
    @Environment(LocationStore.self) var store
    @StateObject var locationManager = LocationManager()
    
    var body: some View {
        NavigationStack {
            Group {
                if locationManager.lastKnownLocation == nil {
                    locationOffView
                } else {
                    scrollView
                }
            }
            .navigationTitle("Near You")
            .onAppear {
                locationManager.start()
            }
        }
    }
    
    var scrollView: some View {
        ScrollView {
            ForEach(store.nearLocations) {
                LocationPreviewView(location: $0)
            }
        }
        .task {
            if let currentLocation = locationManager.lastKnownLocation {
                try? await store.fetchNearLocations(userCords: currentLocation)
            }
        }
    }
    
//    var listView: some View {
//        List {
//            ForEach(exploreModel.locations) { location in
//                LocationPreviewView(location: location)
//                    .background {
//                        NavigationLink("") {
//                            LocationView(location: location)
//                                .onAppear { isShowingMenu = false }
//                                .onDisappear { isShowingMenu = true }
//                        }
//                        .opacity(0.0)
//                    }
//                    .listRowSeparator(.hidden)
//                    .listRowInsets(EdgeInsets())
//                    .task {
//                        if location == exploreModel.locations.last {
//                            try? await exploreModel.populateLocations()
//                        }
//                    }
//            }
//        }
//        .listStyle(.plain)
//        .listRowSpacing(30)
//    }
//    
    var locationOffView: some View {
        VStack {
            ContentUnavailableView("Share your location to experience the haunt nearby", systemImage: "location.slash")
                .overlay {
                    LocationButton {
                        locationManager.start()
                    }
                    .clipShape(Capsule())
                    .offset(y: 100)
                }
        }
    }
}

#Preview {
    NearView()
        .environment(LocationStore())
        .environmentObject(LocationManager())
}
