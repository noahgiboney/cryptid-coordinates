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
        ContentUnavailableView(message, systemImage: "location")
            .overlay {
                Button {
                    locationManager.start()
                } label: {
                    Label("Current Location", systemImage: "location.fill")
                }
                .buttonStyle(.bordered)
                .offset(y: 100)
            }
    }
}

#Preview {
    LocationUnavailableView(message: "Share your location to experience the haunt near you")
        .environmentObject(LocationManager())
}
