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
    
    var body: some View {
        Group {
            if saved.locations.isEmpty {
                ContentUnavailableView("No Locations Saved", systemImage: "house.lodge")
            } else{
                SavedListView(locations: saved.locations)
            }
        }
        .navigationTitle("Saved")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButton()
            }
        }
    }
}

struct SavedListView: View {
    var locations: Set<String>
    @Environment(Saved.self) var saved
    @Query var savedLocations: [Location]
    
    init(locations: Set<String>) {
        self.locations = locations
        self._savedLocations = .init(filter: #Predicate<Location> { locations.contains($0.id) }, sort: [SortDescriptor(\Location.name)], animation: .default)
    }
    
    var body: some View {
        List(savedLocations) { location in
            LocationRowView(location: location)
                .swipeActions {
                    Button {
                        saved.update(location)
                    } label: {
                        Image(systemName: "trash")
                    }
                    .tint(.red)
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

