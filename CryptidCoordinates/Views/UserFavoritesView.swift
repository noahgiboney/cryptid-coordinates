//
//  UserFavoritesView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 1/26/24.
//

import SwiftUI

struct UserFavoritesView: View {
    
    enum SortType: String {
        case newest, oldest
    }
    
    @AppStorage("sortBy") var sortSelection: SortType = .newest
    @Environment(UserFavorites.self) private var userFavorites
    @Environment(\.dismiss) var dismiss
    
    var sortedList: [HauntedLocation] {
        
        switch sortSelection {
        case .newest:
            return userFavorites.locations.reversed()
        case .oldest:
            return userFavorites.locations
        }
    }

    var body: some View {
        NavigationStack{
            
            locationList
                .navigationTitle("Your Locations")
                .toolbar {
                    ToolbarItem(placement: .topBarLeading){
                        Button("Dismiss") {
                            dismiss()
                        }
                    }
                    
                    ToolbarItem{
                        Menu("Sort By", systemImage: "arrow.up.arrow.down.circle") {
                            Picker("Sort y", selection: $sortSelection) {
                                Text("Newest")
                                    .tag(SortType.newest)
                                Text("Oldest")
                                    .tag(SortType.oldest)
                            }
                        }
                    }
                    
                    ToolbarItem{
                        EditButton()
                    }
                }
        }
    }
}

#Preview {
    UserFavoritesView().environment(UserFavorites())
}

extension UserFavoritesView {
    
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
                    userFavorites.locations.remove(atOffsets: indexSet)
                })
            }
        }
    }
}
