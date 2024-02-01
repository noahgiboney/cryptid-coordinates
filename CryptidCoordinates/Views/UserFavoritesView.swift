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
    
    var body: some View {
        NavigationStack{
            
            locationList
                .navigationTitle("Your Locations")
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
