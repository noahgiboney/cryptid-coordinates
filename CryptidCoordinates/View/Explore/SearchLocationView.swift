//
//  SearchLocationView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 7/22/24.
//

import SwiftData
import SwiftUI

struct SearchLocationView: View {
    var searchText: String
    @Environment(Saved.self) var saved
    @Environment(\.modelContext) var modelContext
    @State private var locations: [Location] = []
    @State private var offset = 0
    @State private var isFetching = false
    
    var body: some View {
        Group {
            if locations.isEmpty {
                ContentUnavailableView.search(text: searchText)
                    .listRowSeparator(.hidden)
            } else {
                ForEach(locations) { location in
                    LocationRowView(location: location)
                        .onAppear {
                            if location.id == locations.last?.id {
                                try? fetchLocations()
                            }
                        }
                        .swipeActions {
                            Button {
                                saved.update(location)
                            } label: {
                                Image(systemName: saved.contains(location) ? "bookmark.slash.fill" : "bookmark")
                            }
                            .tint(saved.contains(location) ? .red : .accent)
                        }
                }
            }
        }
        .onChange(of: searchText) { oldValue, newValue in
            if !searchText.isEmpty {
                locations.removeAll()
                offset = 0
                try? fetchLocations()
            }
        }
        .onAppear {
            if !searchText.isEmpty {
                try? fetchLocations()
            }
        }    }
    
    func fetchLocations() throws {
        guard !isFetching else { return }
        isFetching = true
        
        let limit = 50
        var descriptor = FetchDescriptor<Location>(predicate: #Predicate<Location> { location in
            location.name.localizedStandardContains(searchText) ||
            location.city.localizedStandardContains(searchText)
        }, sortBy: [SortDescriptor(\Location.name)])
        
        descriptor.fetchLimit = limit
        descriptor.fetchOffset = limit * offset
        
        let newLocations = try modelContext.fetch(descriptor)
        locations.append(contentsOf: newLocations)
        offset += 1
        isFetching = false
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Location.self, configurations: config)
    
    return ExploreView().modelContainer(container)
}
