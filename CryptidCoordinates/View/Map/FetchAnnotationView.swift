//
//  FetchAnnotationView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 7/23/24.
//

import MapKit
import SwiftData
import SwiftUI

struct FetchAnnotationView: View {
    var geohashes: [String]
    @Binding var cameraPosition: MapCameraPosition
    @State private var selectedLocation: Location?
    @Query var annotations: [Location]
    
    init(cameraPosition: Binding<MapCameraPosition>, geohashes: [String]) {
        self._cameraPosition = cameraPosition
        self.geohashes = geohashes
        
        self._annotations = .init(filter: #Predicate {
            geohashes.contains($0.geohash)
        }, animation: .default)
    }
    
    var body: some View {
        Map(position: $cameraPosition, interactionModes: .all) {
            UserAnnotation()
            
            ForEach(annotations) { location in
                Annotation("", coordinate: location.coordinates) {
                    LocationMarkerView(url: location.url)
                        .onTapGesture {
                            selectedLocation = location
                        }
                }
            }
        }
        .mapControls {
            MapUserLocationButton()
        }
        .sheet(item: $selectedLocation) { location in
            LocationView(location: location)
        }
    }
}
