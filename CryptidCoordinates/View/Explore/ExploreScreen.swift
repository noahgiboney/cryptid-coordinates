//
//  ExploreView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 7/13/24.
//

import Kingfisher
import SwiftData
import SwiftUI

struct ExploreScreen: View {
    
    @EnvironmentObject var locationManager: LocationManager
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            List {
                if searchText.isEmpty {
                    Section {
                        if locationManager.lastKnownLocation == nil && !locationManager.isLoadingLocation {
                            LocationUnavailableView(message: "Share your location to explore in your vicinity")
                        } else {
                            NearYouView(geohashes: locationManager.geohashes)
                        }
                    }
                    .listRowSeparator(.hidden)
                    
                    Section {
                        TrendingView()
                            .padding(.bottom, 30)
                    }
                    .listRowSeparator(.hidden)
                } else {
                    SearchLocationView(searchText: searchText)
                }
            }
            .navigationTitle("Explore")
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $searchText, prompt: "Search for location or city")
            .listStyle(.plain)
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Location.self, configurations: config)
    
    return ExploreScreen().modelContainer(container).environmentObject(LocationManager())
}
