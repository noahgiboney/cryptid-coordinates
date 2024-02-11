//
//  MapAnnotationView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 2/7/24.
//

import MapKit
import SwiftUI

struct MapAnnotationView: View {
    
    var image: String
    
    var body: some View {
        
        ZStack {
            Image(systemName: "triangle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 10, height: 10)
                .offset(y: -16)
                .foregroundColor(.black)
                .rotationEffect(.degrees(180))
            
            Circle()
                .fill(.black)
                .frame(width: 30, height: 30)
            
            if image == "ghoul" {
                Image(image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 17, height: 17)
                    .shadow(color: .black, radius: 10)
            }
            else {
                Image(systemName: "square.3.layers.3d")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 15, height: 15)
                    .shadow(color: .black, radius: 10)
            }
        }
    }
}

#Preview {
    MapAnnotationView(image: "ghoul")
}
