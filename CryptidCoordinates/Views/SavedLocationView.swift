//
//  UserFavoritesView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 1/26/24.
//

import SwiftData
import SwiftUI

struct SavedLocationsView: View {
    
    enum SortType: String {
        case newest, oldest
    }
    
    @AppStorage("sortBy") var sortSelection: SortType = .newest
    @Environment(\.dismiss) var dismiss
    @State private var viewModel = ViewModel()
    
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
                    Button("Dismiss") {
                        dismiss()
                    }
                }
                
                ToolbarItem{
                    if !viewModel.savedLocations.isEmpty {
                        Menu("Sort By", systemImage: "arrow.up.arrow.down") {
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
                        HStack{
                            VStack(alignment: .leading){
                                Text(location.name)
                                Text(location.cityState)
                                    .font(.caption.italic())
                            }
                            Spacer()
                            Image("ghost")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25)
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
