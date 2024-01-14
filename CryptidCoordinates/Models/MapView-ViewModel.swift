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
    class ViewModel: NSObject, CLLocationManagerDelegate {
        
        var selectedLocation: HauntedLocation?
        
        var cameraPosition: MapCameraPosition = .region(MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 39.83333, longitude: -98.585522),
            span: MKCoordinateSpan(latitudeDelta: 255, longitudeDelta: 255)))
        
        var locationManager: CLLocationManager?
        
        var locations: [HauntedLocation] = Bundle.main.decode(file: "hauntedplaces.json")
        
        private func checkLocationAuthorization() {
            guard let locationManager = locationManager else { return }
            
            switch locationManager.authorizationStatus  {
             
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
                
            case .restricted:
                print("tell them about locations servies, prarental controls ")
                
            case .denied:
                print(" denied ,asign a differnt cord")
                
            case .authorizedAlways, .authorizedWhenInUse:
                cameraPosition = .region(MKCoordinateRegion(
                    center: locationManager.location!.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)))
                
            @unknown default:
                break;
            }
        }
        
        func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            checkLocationAuthorization()
        }
        
        func checkIfLocationsEnabled() {
            locationManager = CLLocationManager()
            locationManager!.delegate = self
        }
        
        func updateSelectedLocation(location: HauntedLocation) {
            selectedLocation = location
        }
    }
}
