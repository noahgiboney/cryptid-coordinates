//
//  MapView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 1/9/24.
//
import MapKit
import SwiftUI

struct OldMap: View {
    
    @State private var viewModel = ViewModel()
    
    var body: some View {
        NavigationStack{
            ZStack(alignment: .top){
                
                Map(position: $viewModel.cameraPosition){
                    ForEach(viewModel.displayedLocations) { location in
                        Annotation(location.name, coordinate: location.coordinates) {
                            MapAnnotationView()
                                .onTapGesture(perform: {
                                    viewModel.updateSelectedLocation(location: location)
                                })
                        }
                    }
                    
                }
                .onMapCameraChange{ mapCameraUpdateContext in
                    viewModel.getDisplayedLocations(center: mapCameraUpdateContext.camera.centerCoordinate)
                }
                .onAppear {
                    if let center = viewModel.cameraPosition.camera?.centerCoordinate {
                        viewModel.getDisplayedLocations(center: center)
                    }
                }
            }
            // map
            .mapStyle(.hybrid)

            .tint(Color.green)
//            .onAppear {
//                viewModel.checkIfLocationsEnabled()
//            }
            // city search view
        }
    }
}

#Preview {
    OldMap()
}
