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
            ZStack {
                LinearGradient(colors: [.black, .clear], startPoint: .bottom, endPoint: .top)
                    .clipShape(Circle())
                    .shadow(radius: 2, x:0, y: 2)
                
                Image(systemName: "square.3.layers.3d")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.white)
                    .padding(10)
            }
            .frame(width: 40, height: 40)
            
            Image(systemName: "triangle.fill")
                .font(.system(size: 12))
                .offset(y: 5)
                .rotationEffect(.degrees(180))
                .foregroundColor(.black)
        }
    }
}

#Preview {
    MapClusterView()
}

