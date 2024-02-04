//
//  MapClusterView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 1/16/24.
//

import SwiftUI

struct MapClusterView: View {
    var body: some View {
        VStack {
            Image(systemName: "square.3.layers.3d")
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25)
        }
    }
}

#Preview {
    MapClusterView()
}

