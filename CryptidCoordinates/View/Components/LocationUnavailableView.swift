//
//  LocationUnavailableView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 7/16/24.
//

import SwiftUI

struct LocationUnavailableView: View {
    var message: String
    @EnvironmentObject var locationManager: LocationManager
    
    var body: some View {
        ContentUnavailableView(label: {
            Label("Location Unavailable", systemImage: "location")
        }, description: {
            Text(message)
        }, actions: {
            Button {
                locationManager.start()
            } label: {
                Label("Current Location", systemImage: "location.fill")
            }
            .buttonStyle(.bordered)
        })
    }
}

#Preview {
    LocationUnavailableView(message: "Share your location to experience the haunt near you")
        .environmentObject(LocationManager())
}
