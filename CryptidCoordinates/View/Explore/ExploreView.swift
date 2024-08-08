//
//  ExploreView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 7/13/24.
//

import Kingfisher
import SwiftData
import SwiftUI

struct ExploreView: View {
    @EnvironmentObject var locationManager: LocationManager
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            List {
                if searchText.isEmpty {
                    Section {
                        Text("Near You")
                            .font(.title2.bold())
                        
                        if locationManager.lastKnownLocation == nil && !locationManager.isLoadingLocation {
                            LocationUnavailableView(message: "Share your location to explore in your vicinity")
                        } else {
                            NearYouView(geohashes: locationManager.geohashes)
                        }
                    }
                    .listRowSeparator(.hidden)
                    
                    Section {
                        Text("Trending")
                            .font(.title2.bold())
                        
                        TrendingView()
                    }
                    .listRowSeparator(.hidden)
                } else {
                    SearchLocationView(searchText: searchText)
                }
            }
            .navigationTitle("Explore")
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search for location or city")
            .listStyle(.plain)
            .listRowSpacing(5)
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Location.self, configurations: config)
    
    return ExploreView().modelContainer(container).environmentObject(LocationManager())
}
