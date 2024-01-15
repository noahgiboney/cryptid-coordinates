//
//  HauntedCitiesListView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 1/13/24.
//

import SwiftUI

struct SearchListView: View {
    
    @Environment(\.dismiss) var dismiss
    @State private var viewModel = ViewModel()
    
    var body: some View {
        NavigationStack{
            ZStack{
                List(viewModel.searchList, id: \.self) { city in
                    Text(city)
                }
            }
            .navigationTitle("Cryptid Locations")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search for a city")
        }
    }
}

#Preview {
    SearchListView()
}
