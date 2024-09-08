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
    @State private var exploreTab: ExploreTab = .nearYou
    
    var body: some View {
        NavigationStack {
            List {
                if searchText.isEmpty {
                    Section {
                        Picker("", selection: $exploreTab) {
                            ForEach(ExploreTab.allCases) { tab in
                                Text(tab.title).tag(tab)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    .listRowSeparator(.hidden)
                    switch exploreTab {
                    case .nearYou:
                        NearYouView(geohashes: locationManager.geohashes)
                    case .trending:
                        TrendingView()
                    case .new:
                        NewLocationsView()
                    }

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
