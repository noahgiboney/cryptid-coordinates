//
//  HauntedCitiesListView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 1/13/24.
//

import SwiftUI

struct HauntedCitiesListView: View {
    
    
    @State private var searchTerm = ""
    
    let arr = [1,2,3,4]
    
    var body: some View {
        NavigationStack{
            List(arr, id: \.self) {
                Text("\($0)")
            }
            .navigationTitle("Haunted Cities")
            .searchable(text: $searchTerm, prompt: "Search for a haunted city")
        }
    }
}

#Preview {
    HauntedCitiesListView()
}
