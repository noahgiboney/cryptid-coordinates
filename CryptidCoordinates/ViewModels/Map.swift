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
        
        // region that the camera is showing on the map
        var cameraPosition: MapCameraPosition = .userLocation(fallback: .automatic)
        
        // lcoation to show if the user selects one
        var selectedLocation: HauntedLocation?
        
        // sheets to show on toggle
        var showingSearch = false
        var showingUserFavorites = false
        
        // locations to display on map
        var displayedLocations = [HauntedLocation]()
    
        // manage user location
        var locationManager: CLLocationManager?
        
        // execute when marker is tapped
        func tappedMarker(marker: MKMapItem) {
            selectedLocation = getLocation(for: marker)
        }
        
        // converts the marker to the haunted location
        func getLocation(for item: MKMapItem) -> HauntedLocation? {
            if let index = HauntedLocation.allLocations.firstIndex(where: { location in
                location.coordinates == item.coordinate
            }) {
                return HauntedLocation.allLocations[index]
            }
            return nil
        }
        
        // update map camera to some point
        func updateCamera(to point: CLLocationCoordinate2D, span: Double) {
            withAnimation(.smooth(duration: 1.5)){
                cameraPosition = .region(MKCoordinateRegion(center: point, span: MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span)))
            }
        }
        
        // calculates locations around the center of the map center
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
    }
}
