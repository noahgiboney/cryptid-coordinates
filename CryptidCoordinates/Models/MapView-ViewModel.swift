//
//  MapView-ViewModel.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 1/9/24.
//

import Foundation
import Observation
import MapKit
import SwiftUI

extension MapView{
    @Observable
    class ViewModel {
        
        var cameraPosition: MapCameraPosition = .region(MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 39.83333, longitude: -98.585522),
            span: MKCoordinateSpan(latitudeDelta: 50, longitudeDelta: 50)))
        
        
        func loadLocations() {
            
        }
    }
}
