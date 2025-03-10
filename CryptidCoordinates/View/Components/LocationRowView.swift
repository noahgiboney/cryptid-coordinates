//
//  LocationRowView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 7/22/24.
//

import SwiftUI

struct LocationRowView: View {
    
    let location: Location
    
    var body: some View {
        NavigationLink {
            LocationContainer(location: location)
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
