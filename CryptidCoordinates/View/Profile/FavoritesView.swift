//
//  FavoritesView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 7/11/24.
//

import Kingfisher
import SwiftUI

struct FavoritesView: View {
    @State private var locations: [Location] = Array(repeating: .example, count: 20)
    //@State private var locations: [Location] = []
    @State private var searchText = ""
    
    var filteredList: [Location] {
        if searchText.isEmpty {
            return locations
        } else {
            return locations.filter { $0.name.localizedStandardContains(searchText) }
        }
    }
    
    var body: some View {
        Group {
            if !filteredList.isEmpty {
                List {
                    ForEach(locations) { location in
                        NavigationLink {
                            LocationView(location: location)
                        } label: {
                            VStack(alignment: .leading) {
                                Text(location.name)
                                Text(location.cityState)
                                    .font(.footnote)
                                    .foregroundStyle(.gray)
                            }
                        }
                    }
                }
            } else if locations.isEmpty {
                ContentUnavailableView("No locations yet", systemImage: "house.lodge")
            } else {
                ContentUnavailableView.search
            }
        }
        .navigationTitle("Favorites")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .searchable(text: $searchText)
        .toolbar {
            if !locations.isEmpty {
                ToolbarItem(placement: .topBarTrailing){
                    EditButton()
                }
            }
            
            ToolbarItem(placement: .topBarLeading){
                BackButton()
            }
        }
    }
}

#Preview {
    NavigationStack {
        FavoritesView()
    }
}
