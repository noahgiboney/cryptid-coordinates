//
//  MapView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 7/23/24.
//

import MapKit
import SwiftData
import SwiftUI

struct MapView: View {
    var geohashes: [String]
    @Environment(GlobalModel.self) var global
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
            NavigationStack {
                LocationView(location: location)
                    .overlay(alignment: .topTrailing) {
                        Button {
                            selectedLocation = nil
                        } label: {
                            Image(systemName: "xmark")
                                .padding(10)
                                .background(.ultraThinMaterial, in: Circle())
                                .padding()
                        }
                    }
            }
        }
        .onChange(of: global.selectedLocation) { oldValue, newValue in
            if let location = global.selectedLocation {
                goToSelectedLocation(location)
            }
        }
    }
    
    func goToSelectedLocation(_ location: Location) {
        cameraPosition = location.cameraPosition
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation {
                cameraPosition = .region(MKCoordinateRegion(center: location.coordinates, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)))
            }
        }
    }
}
