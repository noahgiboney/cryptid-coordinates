//
//  LocationDetail.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 1/9/24.
//

import SwiftUI

struct LocationDetail: View {
    
    var location: HauntedLocation
    
    var body: some View {
        NavigationStack{
            VStack{
                
            }
            .navigationTitle(location.name)
        }
    }
}

#Preview {
    LocationDetail(location: HauntedLocation.example)
}
