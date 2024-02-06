//
//  UserFavoritesView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 1/26/24.
//

import SwiftUI

struct SavedLocationsView: View {
    
    @AppStorage("sortBy") var sortSelection: SortType = .newest
    @Environment(\.dismiss) var dismiss
    @State private var viewModel = ViewModel()
    
    // sort list based on selection
    var sortedList: [HauntedLocation] {
        switch sortSelection {
        case .newest:
            return viewModel.savedLocations.reversed()
        case .oldest:
            return viewModel.savedLocations
        }
    }
    
    var body: some View {
        NavigationStack{
            VStack{
                if viewModel.savedLocations.isEmpty {
                    ContentUnavailableView("No Locations Saved Yet", image: "ghost")
                }
                else {
                    locationList
                }
            }
            .navigationTitle("Your Locations")
            .toolbar {
                ToolbarItem(placement: .topBarLeading){
                    Button("Close") {
                        dismiss()
                    }
                }
                ToolbarItem{
                    if !viewModel.savedLocations.isEmpty {
                        Menu("Sort By", systemImage: "line.3.horizontal.decrease.circle") {
                            Picker("Sort y", selection: $sortSelection) {
                                Text("Newest")
                                    .tag(SortType.newest)
                                Text("Oldest")
                                    .tag(SortType.oldest)
                            }
                        }
                    }
                    
                    
                }
                ToolbarItem{
                    if !viewModel.savedLocations.isEmpty{
                        EditButton()
                    }
                }
            }
            .onAppear {
                viewModel.loadSavedLocations()
            }
        }
    }
}

#Preview {
    SavedLocationsView()
}

extension SavedLocationsView {
    
    private var locationList: some View {
        VStack{
            List {
                ForEach(sortedList) { location in
                    NavigationLink{
                        LocationDetailView(location: location)
                            .navigationBarTitleDisplayMode(.inline)
                    }  label: {
                        VStack(alignment: .leading){
                            Text(location.name)
                            Text(location.cityState)
                                .font(.caption.italic())
                        }
                    }
                }
                .onDelete(perform: { indexSet in
                    viewModel.savedLocations.remove(atOffsets: indexSet)
                })
            }
        }
    }
}
