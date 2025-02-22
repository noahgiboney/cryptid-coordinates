//
//  NewLocationServiceView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 2/21/25.
//

import SwiftUI

struct NewLocationServiceView: View {
    var body: some View {
        Button("Run") {
            Task { await runProcess() }
        }
    }
    
    func runProcess() async {
        do {
            let requests: [LocationRequest] = try await FirebaseService.shared.fetchData(ref: Collections.locationRequests)

            for request in requests {
                
                let geohash = Geohash(coordinates: (request.latitude, request.longitude), precision: 4)?.geohash ?? ""
                
                let newLocation = NewLocation(
                    id: UUID().uuidString,
                    name: request.locationName,
                    country: "United States",
                    city: "",
                    state: "",
                    detail: request.description,
                    longitude: request.longitude,
                    latitude: request.latitude,
                    cityLongitude: 0.0,
                    cityLatitude: 0.0,
                    stateAbbrev: "",
                    imageUrl: "",
                    geohash: geohash,
                    userId: request.isAnonymous ? nil : request.user,
                    timestamp: request.timestamp
                )
                
                try await FirebaseService.shared.setData(object: newLocation, ref: Collections.newLocations)
            }
            
        } catch {
            print("Error run(): \(error.localizedDescription)")
        }
    }
}

#Preview {
    NewLocationServiceView()
}
