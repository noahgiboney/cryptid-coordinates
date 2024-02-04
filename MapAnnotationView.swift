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
            Image("ghost")
                .resizable()
                .scaledToFit()
                .foregroundColor(.white)
                .frame(width: 40, height: 40)
                
            
            Image(systemName: "mappin")
                .font(.system(size: 15))
                .foregroundColor(.white)
                .padding(.bottom, 30)
        }
    }
}

#Preview {
    MapAnnotationView()
}
