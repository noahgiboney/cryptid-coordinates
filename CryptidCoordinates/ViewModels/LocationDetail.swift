//
//  LocationDetailView-ViewModel.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 1/10/24.
//

import MapKit

extension LocationDetailView{
    
    @Observable
    class ViewModel {
        
        // some citys do not have look around support
        var lookAroundPlace: MKLookAroundScene?
        
        // gets the look around preview for some cordinate if it exists
        func fetchLookAroundPreview(for locationCoordinates: CLLocationCoordinate2D) {
            Task {
                let request = MKLookAroundSceneRequest(coordinate: locationCoordinates)
                lookAroundPlace = try? await request.scene
            }
        }
    }
}
