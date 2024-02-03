//
//  LocationDetailView-ViewModel.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 1/10/24.
//

import SwiftUI
import MapKit

extension LocationDetailView{
    
    @Observable
    class ViewModel {
        
        // some citys do not have look around support
        var lookAroundPlace: MKLookAroundScene?
        
        var savedLocations = [HauntedLocation]() {
            didSet {
                let url = URL.documentsDirectory.appending(component: "savedLocations")
                let encoder = JSONEncoder()
                
                let data = try? encoder.encode(savedLocations)
                
                do {
                    try data?.write(to: url)
                    
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        
        // check if some location is already in array
        func isInFavorites(location: HauntedLocation) -> Bool {
            for index in savedLocations {
                if index.coordinates == location.coordinates{
                    return true
                }
            }
            return false
        }
        
        // gets the look around preview for some cordinate if it exists
        func fetchLookAroundPreview(for locationCoordinates: CLLocationCoordinate2D) {
            Task {
                let request = MKLookAroundSceneRequest(coordinate: locationCoordinates)
                lookAroundPlace = try? await request.scene
            }
        }
    }
}
