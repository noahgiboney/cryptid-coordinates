//
//  UserFavoritesView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 1/26/24.
//

import SwiftUI

struct UserFavoritesView: View {
    
    @Environment(UserFavorites.self) private var userFavorites
    @Environment(\.dismiss) var dismiss
    @State private var showingDetail = false
    @State private var tappedLocation: HauntedLocation?
    
    var body: some View {
        NavigationStack{
            locationList
            .onAppear {
                userFavorites.locations.append(HauntedLocation.allLocations[1])
                userFavorites.locations.append(HauntedLocation.allLocations[66])
                userFavorites.locations.append(HauntedLocation.allLocations[951])
            }
            .navigationTitle("Saved Locations")
            .toolbar {
                ToolbarItem{
                    EditButton()
                }
                ToolbarItem(placement: .topBarLeading){
                    Button("Back") {
                        dismiss()
                    }
                }
            }
            .sheet(item: $tappedLocation) { location in
                LocationDetailView(location: location)
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
                ForEach(userFavorites.locations) { location in
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
                    .contentShape(Rectangle())
                    .onTapGesture {
                        tappedLocation = location
                    }
                }

            }
        }
    }
}
