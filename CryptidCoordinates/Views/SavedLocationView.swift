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
    @State private var isEditing = false
    
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
        
        NavigationView{
            
            VStack{
                
                if viewModel.savedLocations.isEmpty {
                    
                    Image("ghoul")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                    
                    Text("No Locations saved yet")
                        .font(.title2)
                        .bold()
                }
                else {
                    locationList
                    
                }
            }
            .navigationTitle("SavedLocations")
            .environment(\.editMode, .constant(self.isEditing ? EditMode.active : EditMode.inactive))
            .toolbar{
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
                
                if !viewModel.savedLocations.isEmpty{
                    ToolbarItem(placement: .topBarTrailing){
                        Button(action: {
                            withAnimation(.spring){
                                isEditing.toggle()
                            }
                        }) {
                            
                            Text(isEditing ? "Done" : "Edit")
                        }
                    }
                }
                
            }
            .sheet(isPresented: $viewModel.showingDetails, content: {
                
                if let location = viewModel.tappedLocation {
                    LocationDetailView(location: location)
                        .onDisappear(perform: {
                            viewModel.loadSavedLocations()
                        })
                }
            })
            .onAppear {
                viewModel.loadSavedLocations()
            }
            .preferredColorScheme(.dark)
        }
    }
}
    

#Preview {
    SavedLocationsView()
}

extension SavedLocationsView {
    
    private var locationList: some View {
        
        List {
            ForEach(viewModel.savedLocations) { location in
                
                HStack{
                    VStack(alignment: .leading){
                        Text(location.name)
                        Text(location.cityState)
                            .font(.caption.italic())
                    }
                    Spacer()
                    Image(systemName: "arrow.down.left.and.arrow.up.right")
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    viewModel.showingDetails.toggle()
                    viewModel.tappedLocation = location
                }
            }
            .onDelete(perform: { indexSet in
                viewModel.savedLocations.remove(atOffsets: indexSet)
            })
        }
    }
}
