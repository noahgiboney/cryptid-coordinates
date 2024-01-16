//
//  MapAnnotationView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 1/15/24.
//

import SwiftUI

struct MapAnnotationView: View {
    var body: some View {
        Image(systemName: "mappin.and.ellipse")
            .resizable()
            .scaledToFit()
            .frame(width: 30, height: 30)
            .foregroundColor(Color.red)
            .padding(.bottom, 4)
    }
}

#Preview {
    MapAnnotationView()
}
