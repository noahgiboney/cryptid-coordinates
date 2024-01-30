//
//  UserFavoritesView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 1/26/24.
//

import SwiftUI

struct UserFavoritesView: View {
    
    @Environment(UserFavorites.self) private var userFavorites
    
    var body: some View {
        NavigationStack{
            List {
                ForEach(userFavorites.locations) { location in
                    Text(location.name)
                }
            }
            .navigationTitle("Saved Locations")
        }
    }
}

#Preview {
    UserFavoritesView().environment(UserFavorites())
}
