//
//  MapView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/14/24.
//

import MapKit
import SwiftUI

struct MapView: View {
    @State private var cameraPosition: MapCameraPosition = .userLocation(fallback: .region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))))
    
    var body: some View {
        Map(position: $cameraPosition, interactionModes: .all) {
            
        }
    }
}

#Preview {
    MapView()
}
