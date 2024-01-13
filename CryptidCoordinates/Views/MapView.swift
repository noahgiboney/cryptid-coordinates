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
        Map(position: $viewModel.cameraPosition){
            UserAnnotation()
            ForEach(viewModel.locations.filter({ location in
                location.city == "Los Angeles"
            })) { location in
                Annotation(location.name, coordinate: location.coordinates) {
                    Image(systemName: "eye")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 44, height: 44)
                        .background(.white)
                        .clipShape(.capsule)
                        .onTapGesture(perform: {
                            viewModel.updateSelectedLocation(location: location)
                        })
                }
            }
        }
        .tint(Color.pink)
        .mapStyle(.hybrid)
        .onAppear {
            viewModel.checkIfLocationsEnabled()
        }
        .sheet(item: $viewModel.selectedLocation){ location in
            if let location = viewModel.selectedLocation {
                LocationDetailView(location: location)
            }
        }
    }
}

#Preview {
    MapView()
}
