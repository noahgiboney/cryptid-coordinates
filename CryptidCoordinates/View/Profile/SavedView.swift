//
//  SavedView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 7/11/24.
//

import Kingfisher
import SwiftData
import SwiftUI

struct SavedView: View {
    @Environment(Saved.self) var saved
    @State private var searchText = ""
    
    var body: some View {
        Group {
            if saved.locations.isEmpty {
                ContentUnavailableView("No Locations Saved", systemImage: "house.lodge")
            } else{
                SavedListView(locations: saved.locations, searchText: searchText)
            }
        }
        .navigationTitle("Saved")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .searchable(text: $searchText)
        .toolbar {
            ToolbarItem(placement: .topBarLeading){
                BackButton()
            }
        }
    }
}

struct SavedListView: View {
    var locations: Set<String>
    var searchText: String
    @Environment(Saved.self) var saved
    @Query var savedLocations: [Location]
    
    init(locations: Set<String>, searchText: String) {
        self.locations = locations
        self.searchText = searchText
        
        var predicate: Predicate<Location>
        
        if searchText.isEmpty {
            predicate = #Predicate { locations.contains($0.id) }
        } else {
            predicate = #Predicate { location in
                return locations.contains(location.id) &&
                location.name.localizedStandardContains(searchText)
            }
        }
        
        self._savedLocations = .init(filter: predicate, sort: [SortDescriptor(\Location.name)], animation: .default)
    }
    
    var body: some View {
        List {
            ForEach(savedLocations) { location in
                LocationRowView(location: location)
                    .swipeActions {
                        Button {
                            saved.update(location)
                        } label: {
                            Image(systemName: "bookmark.slash.fill")
                        }
                        .tint(Color("AccentColor"))
                    }
            }
        }
    }
}

#Preview {
    NavigationStack {
        SavedView()
            .environment(Saved())
    }
}

