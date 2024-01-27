//
//  MapAnnotationView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 1/15/24.
//

import SwiftUI

struct MapAnnotationView: View {
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .foregroundColor(.black)
    
                Image("ghost")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.white)
                    .padding(5)
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
    MapAnnotationView()
}
