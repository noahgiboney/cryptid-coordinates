//
//  MapAnnotationView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 1/15/24.
//

import SwiftUI

struct MapAnnotationView: View {
    var body: some View {
        VStack{
            ZStack{
                Circle()
                Image("ghost")
                    .resizable()
                    .scaledToFit()
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
    MapAnnotationView()
}
