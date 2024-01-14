//
//  HauntedCitiesListView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 1/13/24.
//

import SwiftUI

struct HauntedCitiesListView: View {
    
    @Environment(\.dismiss) var dismiss
    @State private var viewModel = ViewModel()
    
    let arr = [1,2,3,4]
    
    var body: some View {
        NavigationStack{
            List(viewModel.uniqueCities, id: \.self) { location in
                Text(location.city)
            }
            .navigationTitle("Haunted Cities")
            .searchable(text: $viewModel.searchText, prompt: "Search for a haunted city")
        }
    }
}

#Preview {
    HauntedCitiesListView()
}
