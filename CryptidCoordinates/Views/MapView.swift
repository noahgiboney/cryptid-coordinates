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
            
            ForEach(viewModel.locations.filter({ location in
                location.city == "Atlanta"
            })) { location in
                Annotation(location.name, coordinate: location.coordinates) {
                    Image(systemName: "eye")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 44, height: 44)
                        .background(.white)
                }
            }
        }
        .mapStyle(.hybrid)
    }
}

#Preview {
    MapView()
}
