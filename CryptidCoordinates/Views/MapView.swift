//
//  MapView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 1/9/24.
//
import MapKit
import SwiftUI

struct MapView: View {
    var body: some View {
        Map()
            .mapStyle(.hybrid)
    }
}

#Preview {
    MapView()
}
