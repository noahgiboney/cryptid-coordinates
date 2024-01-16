//
//  MapAnotationView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 1/15/24.
//

import SwiftUI

struct MapAnnotationView: View {
    var body: some View {
        VStack{
            Image(systemName: "mappin")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .foregroundColor(.green)
        }
    }
}

#Preview {
    MapAnotationView()
}
