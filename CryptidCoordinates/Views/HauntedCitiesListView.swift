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
    
    @State private var listArray: [HauntedLocation] = []
    
    var body: some View {
        NavigationStack{

            ZStack{
                if viewModel.searchText == "" {
                    ContentUnavailableView("Find a haunted City", systemImage: "waveform.badge.magnifyingglass")
                }
                else {
                    List(listArray, id: \.self) { location in
                        location.city.localizedCaseInsensitiveContains(viewModel.searchText) ? Text(location.city) : nil
                    }
                }
            }
            .onAppear {
                self.listArray = []
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
                    self.listArray = viewModel.searchCities
                }
            }
                
            
            .navigationTitle("Haunted Cities")
            .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search for a haunted city")
        }
//        .onAppear {
//            print(viewModel.searchCities.count)
//        }
    }
}

#Preview {
    HauntedCitiesListView()
}
