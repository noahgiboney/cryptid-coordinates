//
//  ExploreView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 7/13/24.
//

import MapKit
import Kingfisher
import SwiftData
import SwiftUI

struct ExploreScreen: View {
    
    @AppStorage("lastVersionLoadedNewLocations") var lastVersionLoadedNewLocations = ""
    @Environment(\.modelContext) var modelContext
    @Environment(Global.self) var global
    @EnvironmentObject var locationManager: LocationManager
    @State private var searchText = ""
    @State private var exploreTab: ExploreTab = .nearYou
    
    var body: some View {
        NavigationStack {
            List {
                if lastVersionLoadedNewLocations != global.currentAppVersion {
                    ProgressView()
                        .frame(maxWidth: .infinity, alignment: .center)
                        .listRowSeparator(.hidden)
                } else {
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
            }
            .navigationTitle("Explore")
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $searchText, prompt: "Search for location or city")
            .listStyle(.plain)
            .listRowSpacing(40)
            .task {
                if lastVersionLoadedNewLocations != global.currentAppVersion {
                    do {
                        try await loadNewLocations()
                        try await Task.sleep(for: .seconds(1))
                        lastVersionLoadedNewLocations = global.currentAppVersion
                    } catch {
                        print("Error: loadNewLocations(): \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    private func loadNewLocations() async throws {
        let newLocations: [NewLocation] = try await FirebaseService.shared.fetchData(ref: Collections.newLocations)

        try newLocations.forEach { location in
            let newLocation = Location(
                id: location.id,
                name: location.name,
                country: location.country,
                city: location.city,
                state: location.state,
                detail: location.detail,
                longitude: location.longitude,
                latitude: location.latitude,
                cityLongitude: location.cityLongitude,
                cityLatitude: location.cityLatitude,
                stateAbbrev: location.stateAbbrev,
                imageUrl: location.imageUrl,
                geohash: location.geohash
            )
            
            let fetchDescriptor = FetchDescriptor<Location>(predicate: #Predicate<Location> { modelLocation in
                modelLocation.id == location.id
            })
            
            let locationsWithId = try modelContext.fetch(fetchDescriptor)
            
            if locationsWithId.isEmpty {
                modelContext.insert(newLocation)
            }
        }
    }
    
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Location.self, configurations: config)
    
    return ExploreScreen().modelContainer(container).environmentObject(LocationManager())
}
