//
//  MapView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 1/9/24.
//
import MapKit
import SwiftUI

struct MapView: View {
    
    @State private var viewModel = ViewModel()
    
    var body: some View {
        Map(initialPosition: viewModel.cameraPosition){
            
        }
        .mapStyle(.hybrid)
    }
}

#Preview {
    MapView()
}
