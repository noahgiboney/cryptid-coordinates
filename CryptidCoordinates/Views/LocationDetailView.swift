//
//  LocationDetail.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 1/9/24.
//

import SwiftUI

struct LocationDetailView: View {
    
    var location: HauntedLocation
    
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack(alignment: .leading, spacing: 20){
                    
                    Text("\(location.city), \(location.country)")
                        .italic()
                        .font(.headline)
                    
                    Text(location.description)
                    
                }
                .padding()
            }
            .navigationTitle(location.name)
        }
    }
}

#Preview {
    LocationDetailView(location: HauntedLocation.example)
}
