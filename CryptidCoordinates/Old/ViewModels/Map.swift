//
//  MapView-ViewModel.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 1/9/24.
//

import Observation
import MapKit
import SwiftUI

extension OldMap{
    @Observable
    class ViewModel{
        
        // tracks if location has swapped to user location
        var userLocationUpdated = false
        
        // region that the camera is showing on the map
        var cameraPosition: MapCameraPosition = .userLocation(fallback: .region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))))
        
        // lcoation to show if the user selects one
        var selectedLocation: Location?
        
        // sheets to show on toggle
        var showingSearch = false
        var showingUserFavorites = false
        
        // locations to display on map
        var displayedLocations = [Location]()
    
        // manage user location
        var locationManager: CLLocationManager?
        
        // execute when marker is tapped
        func tappedMarker(marker: MKMapItem) {
            selectedLocation = getLocation(for: marker)
        }
        
        // converts the marker to the haunted location
        func getLocation(for item: MKMapItem) -> Location? {
            if let index = Location.allLocations.firstIndex(where: { location in
                location.coordinates == item.coordinate
            }) {
                return Location.allLocations[index]
            }
            return nil
        }
        
        // update map camera to some point
        func updateCamera(to point: CLLocationCoordinate2D, span: Double) {
            withAnimation(.easeIn){
                cameraPosition = .region(MKCoordinateRegion(center: point, span: MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span)))
            }
        }
    }
}
