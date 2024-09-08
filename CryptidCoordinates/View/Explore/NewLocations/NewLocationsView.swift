//
//  NewLocationsView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 9/6/24.
//

import SwiftData
import SwiftUI

struct NewLocationsView: View {
    
    @Environment(LocationStore.self) var locations
    @State private var showSubmitRequest = false
    
    var body: some View {
        ExploreTabContainer(title: "New", description: "The newest added by users") {
            VStack(alignment: .leading, spacing: 10) {
                Text("Know of a huanted location not on the platform? Add it here!")
                
                Button("Submit Location", systemImage: "square.and.pencil") {
                    showSubmitRequest.toggle()
                }
                .buttonStyle(.borderless)
            }
            .listRowSeparator(.hidden)
                
            Divider().listRowSeparator(.hidden)
            
            NewLocationsScrollView(ids: locations.new)
        }
        .task {
            await locations.fetchNewLocations()
        }
        .fullScreenCover(isPresented: $showSubmitRequest) {
            SubmitLocationDetailsView(showCover: $showSubmitRequest)
        }
    }
}

struct NewLocationsScrollView: View {
    
    let ids: [String]
    @Query var locations: [Location]
    
    init(ids: [String]) {
        self.ids = ids
        _locations = .init(filter: #Predicate { ids.contains($0.id) })
    }
    
    var body: some View {
        ForEach(locations) { location in
            Text(location.name)
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
