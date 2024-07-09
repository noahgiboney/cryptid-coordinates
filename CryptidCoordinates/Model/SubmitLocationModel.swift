//
//  RequestModel.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/16/24.
//

import FirebaseAuth
import MapKit
import SwiftUI

@Observable
class SubmitLocationModel {
    private let firebaseService = FirebaseService.shared
    
    var locationName = ""
    var description = ""
    var coordinates: CLLocationCoordinate2D?
    var isShowingAlert = false
    var alertMessage = ""
    
    func sumbitRequest() async throws {
        guard let cords = coordinates,
        let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        let newRequest = LocationRequest(user: currentUserId, locationName: locationName, description: description, latitude: cords.latitude, longitude: cords.latitude)
        
        do {
            try await firebaseService.submitRequest(location: newRequest)
            alertMessage = "Your request for \(locationName) has been sent. Keep an eye out for it be featured on the platform!"
            isShowingAlert.toggle()
        } catch {
            print("DEBUG: error sumbmitting location request with error: \(error.localizedDescription)")
        }
    }
}
