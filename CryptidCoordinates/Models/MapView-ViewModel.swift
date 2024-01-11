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
        
        var selectedLocation: HauntedLocation?
        
        private(set) var cameraPosition: MapCameraPosition = .region(MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 39.83333, longitude: -98.585522),
            span: MKCoordinateSpan(latitudeDelta: 255, longitudeDelta: 255)))
        
            
        var locations: [HauntedLocation] = Bundle.main.decode(file: "hauntedplaces.json")
        
        func updateSelectedLocation(location: HauntedLocation) {
            selectedLocation = location
        }
    }
}
