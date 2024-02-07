//
//  MapAnnotationView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 2/7/24.
//

import SwiftUI

struct MapAnnotationView: View {
    
    var body: some View {
        
        Image("ghost")
            .resizable()
            .scaledToFill()
            .frame(width: 40, height: 40)
    }
}

#Preview {
    MapAnnotationView()
}
