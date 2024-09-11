//
//  NewLocationsView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 9/6/24.
//

import Firebase
import SwiftData
import SwiftUI

struct NewLocationsView: View {
    
    @AppStorage("lastVersionLoadedNewLocations") var lastVersionLoadedNewLocations = ""
    @Environment(Global.self) var global
    @Environment(LocationStore.self) var locations
    @Environment(\.modelContext) var modelContext
    @State private var showSubmitRequest = false
    @State private var didAppear = false
    
    var body: some View {
        ExploreTabContainer(title: "New", description: "Locations added by users") {
            VStack(spacing: 15) {
                Button("Submit Location", systemImage: "square.and.pencil") {
                    showSubmitRequest.toggle()
                }
                .buttonStyle(.borderless)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 20)
                
                Divider()
            }
            .padding(.top)
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets())
            .fullScreenCover(isPresented: $showSubmitRequest) {
                SubmitLocationDetailsView(showCover: $showSubmitRequest)
            }
            
            ScrollView {
                LazyVStack(spacing: 35) {
                    ForEach(locations.new) { location in
                        NewLocationCellView(newLocation: location)
                    }
                    .listRowInsets(EdgeInsets())
                }
            }
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets())
            .padding(.vertical, 30)
        }
        .task {
            if lastVersionLoadedNewLocations != global.currentAppVersion {
                do {
                    try await loadNewLocations()
                    lastVersionLoadedNewLocations = global.currentAppVersion
                } catch {
                    print("Error: loadNewLocations(): \(error.localizedDescription)")
                }
            }
            
            guard !didAppear else { return }
            await locations.fetchNewLocations()
            didAppear = true
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
    List {
        NewLocationsView()
            .environment(LocationStore())
    }
    .listStyle(.plain)
}
