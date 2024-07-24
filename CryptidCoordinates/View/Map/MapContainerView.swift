//
//  MapContainerView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/14/24.
//

import MapKit
import SwiftUI

struct MapContainerView: View {
    @Environment(GlobalModel.self) var global
    @State private var cameraPosition: MapCameraPosition = .userLocation(fallback: .region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))))
    @State private var geohashes: [String] = []
    
    var body: some View {
        MapView(cameraPosition: $cameraPosition, geohashes: geohashes)
            .onMapCameraChange { context in
                updateGeohash(context: context)
            }
    }
    
    func updateGeohash(context: MapCameraUpdateContext) {
        let center = context.camera.centerCoordinate
        let centerGeohash = Geohash(coordinates: (center.latitude, center.longitude), precision: 4)
        
        if var neighbors = centerGeohash?.neighbors?.all.compactMap( { $0.geohash }) {
            if let centerGeohash = centerGeohash?.geohash {
                neighbors.append(centerGeohash)
                geohashes = neighbors
            }
        }
    }
    
    func selectedLocation(currentCordinates: CLLocationCoordinate2D) {
        withAnimation(.easeInOut(duration: 0.1)){
            cameraPosition = .region(MKCoordinateRegion(center: currentCordinates, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)))
            
        }
    }
}

#Preview {
    MapContainerView()
        .environment(GlobalModel(user: .example))
}
