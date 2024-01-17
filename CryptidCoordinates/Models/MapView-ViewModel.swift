//
//  MapView-ViewModel.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 1/9/24.
//

import Observation
import MapKit
import SwiftUI

extension MapView{
    @Observable
    class ViewModel: NSObject, CLLocationManagerDelegate {
        
        var cameraPosition: MapCameraPosition = .region(MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 39.83333, longitude: -98.585522),
            span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)))
        
        var showingSearch = false

        var locationManager: CLLocationManager?
        
        var displayedLocations = [HauntedLocation]()
        
        func getDisplayedLocations(center: CLLocationCoordinate2D) {
            displayedLocations = HauntedLocation.allLocations.filter { location in
    
                guard let longitude = Double(location.longitude), let latitude = Double(location.latitude) else {
                    return false
                }
                
                let lowerBoundLong = longitude - 2
                let upperBoundLong = longitude + 2
                
                let lowerBoundLat = latitude - 2
                let upperBoundLat = latitude + 2
                
                return center.longitude >= lowerBoundLong && center.longitude <= upperBoundLong &&
                center.latitude >= lowerBoundLat && center.latitude <= upperBoundLat
            }
        }
        
        func getNearestLocations(for startingLocation: HauntedLocation) -> [HauntedLocation] {
            var array = HauntedLocation.allLocations
            
            guard let startingLatitude = Double(startingLocation.latitude),
                  let startingLongitude = Double(startingLocation.longitude) else {
                return []
            }
            
            let current = CLLocation(latitude: startingLatitude, longitude: startingLongitude)
            
            var dictArray = array.compactMap { (location: HauntedLocation) -> [String: Any]? in
                guard let locationLatitude = Double(location.latitude),
                      let locationLongitude = Double(location.longitude) else {
                    return nil
                }
                
                return ["distance": current.distance(from: CLLocation(latitude: locationLatitude, longitude: locationLongitude)),
                        "coordinate": location]
            }
            
            dictArray.sort { ($0["distance"] as! CLLocationDistance) < ($1["distance"] as! CLLocationDistance) }
            
            var sortedLocations = dictArray.compactMap { $0["coordinate"] as? HauntedLocation }
            
            sortedLocations.insert(startingLocation, at: 0)
            
            return sortedLocations
        }
        
        
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
    }
}
