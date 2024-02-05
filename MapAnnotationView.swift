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
                .frame(width: 40, height: 40)
                .padding(30)
        }
    }
}

#Preview {
    MapAnnotationView()
}
