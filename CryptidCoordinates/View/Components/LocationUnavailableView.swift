//
//  LocationUnavailableView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 7/16/24.
//

import SwiftUI

struct LocationUnavailableView: View {
    
    let message: String
    @EnvironmentObject var locationManager: LocationManager
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ContentUnavailableView(label: {
            Label("Location Unavailable", systemImage: "location")
        }, description: {
            Text(message)
        }, actions: {
            Button {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
                dismiss()
            } label: {
                Label("Share Location", systemImage: "location.fill")
            }
            .buttonStyle(.bordered)
            .foregroundStyle(.blue)
        })
    }
}

#Preview {
    LocationUnavailableView(message: "Share your location to experience the haunt near you")
        .environmentObject(LocationManager())
}
