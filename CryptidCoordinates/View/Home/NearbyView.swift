//
//  NearYouView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 7/6/24.
//

import CoreLocationUI
import SwiftUI

struct NearbyView: View {
    @StateObject var locationManager = LocationManager()
    
    var body: some View {
        NavigationStack {
            VStack {
                if locationManager.lastKnownLocation == nil {
                    LocationOffView
                } else {
                    
                }
            }
            .navigationTitle("Near You")
            .onAppear {
                locationManager.start()
            }
        }
    }
    
    private var LocationOffView: some View {
        VStack {
            ContentUnavailableView("Share your location to view the haunt nearby", systemImage: "location.slash")
                .overlay {
                    LocationButton {
                        locationManager.start()
                    }
                    .clipShape(Capsule())
                    .offset(y: 100)
                }
        }
    }
}

#Preview {
    NearbyView()
}
