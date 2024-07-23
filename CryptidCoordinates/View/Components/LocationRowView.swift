//
//  LocationRowView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 7/22/24.
//

import SwiftUI

struct LocationRowView: View {
    var location: Location
    
    var body: some View {
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
