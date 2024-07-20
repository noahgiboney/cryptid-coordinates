//
//  NearView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 7/6/24.
//

import CoreLocationUI
import SwiftUI

struct NearView: View {
    @Environment(LocationStore.self) var store
    @EnvironmentObject var locationManager: LocationManager
    
    var body: some View {
        NavigationStack {
            Group {
                if locationManager.lastKnownLocation == nil {
                    LocationUnavailableView(message: "Share your location to experience the haunt near you")
                } else {
                    scrollView
                }
            }
            .navigationTitle("Near You")
        }
    }
    
    var scrollView: some View {
        ScrollView {
            VStack(spacing: 45){
                if store.didLoadNearLocations {
                    ForEach(store.nearLocations) { location in
                        NavigationLink {
                            LocationView(location: location)
                        } label: {
                            LocationPreviewView(location: location, size: .preview)
                        }
                    }
                } else {
                    LoadingView()
                        .offset(y: 100)
                }
            }
        }
        .task {
            if let currentLocation = locationManager.lastKnownLocation {
                try? await store.fetchNearLocations(userCords: currentLocation)
            }
        }
    }
}

#Preview {
    NearView()
        .environment(LocationStore())
        .environmentObject(LocationManager())
        .preferredColorScheme(.dark)
}
