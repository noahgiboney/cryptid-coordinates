//
//  MapClusterView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 1/16/24.
//

import SwiftUI

struct MapClusterView: View {
    var body: some View {
        VStack{
            ZStack{
                Circle()
                Image(systemName: "square.3.layers.3d")
                    .foregroundStyle(Color.white)
            }
            .frame(width: 35)
            
            Image(systemName: "triangle.fill")
                .offset(y: 7)
                .rotationEffect(.degrees(180))
                .imageScale(.small)
        }
    }
}

#Preview {
    MapClusterView()
}
