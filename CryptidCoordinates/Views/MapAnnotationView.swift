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
                .frame(width: 20, height: 20)
                .offset(y: -20)
                .foregroundColor(.black)
                .rotationEffect(.degrees(180))
                .shadow(color: .gray, radius: 2, x: 0, y: -1)
            
            Circle()
                .fill(LinearGradient(gradient: Gradient(colors: [.black, .gray]), startPoint: .top, endPoint: .bottom))
                .frame(width: 40, height: 40)
                .shadow(radius: 5)
            
            if image == "ghoul" {
                Image(image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .clipShape(Circle())
                    .shadow(color: .black, radius: 3, x: 0, y: 2)
            } else {
                Image(systemName: "square.3.layers.3d")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .shadow(color: .black, radius: 3, x: 0, y: 2)
            }
        }
        .padding(.bottom, 20) 
    }
}

#Preview {
    MapAnnotationView(image: "ghoul")
}
