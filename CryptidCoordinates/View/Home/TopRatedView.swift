//
//  TopRatedView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/14/24.
//

import SwiftUI

struct TopRatedView: View {
    let location: OldLocation
    
    var body: some View {
        VStack {
            VStack(alignment: .leading){
                Text(location.name)
                    .font(.headline)
                
                Text(location.cityState)
                    .font(.footnote)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

#Preview {
    TopRatedView(location: OldLocation.example)
}
