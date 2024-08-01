//
//  ViewModel.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/14/24.
//

import Firebase
import MapKit
import SwiftUI

@Observable
class GlobalModel {
    
    var user: User
    var tabSelection = 0
    var cameraPosition: MapCameraPosition
    
    init(user: User, defaultCords: CLLocationCoordinate2D) {
        self.user = user
        self.cameraPosition = .region(MKCoordinateRegion(center: defaultCords, span: MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.15)))
    }
    
    var selectedLocation: Location? {
        didSet {
            if let location = selectedLocation {
                tabSelection = 1
                goToSelectedLocation(location)
            }
        }
    }
    
    private func goToSelectedLocation(_ location: Location) {
        self.cameraPosition = location.cameraPosition
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
            withAnimation {
                self.cameraPosition = .region(MKCoordinateRegion(center: location.coordinates, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)))
            }
            self.selectedLocation = nil
        }
    }
}
