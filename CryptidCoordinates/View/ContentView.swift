//
//  ContentView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/12/24.
//

import FirebaseFirestore
import FirebaseCore
import MapKit
import SwiftData
import SwiftUI

struct ContentView: View {
    
    @AppStorage("lastVersionLoadedNewLocations") var lastVersionLoadedNewLocations = ""
    @AppStorage("isContextPopulated") var isContextPopulated = false
    @Environment(\.modelContext) var modelContext
    @StateObject private var locationManager = LocationManager()
    @State private var authModel = AuthModel()
    
    let currentVersion = "2.5"
    
    var defaultCords: CLLocationCoordinate2D {
        locationManager.lastKnownLocation ?? CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
    }
    
    var body: some View {
        Group {
            if authModel.userSession != nil {
                if let user = authModel.currentUser {
                    TabBarView(currentUser: user, defaultCords: defaultCords)
                        .onAppear {
                            locationManager.start()
                        }
                }
            } else {
                LandingScreen()
            }
        }
        .environment(authModel)
        .environmentObject(locationManager)
        .onAppear {
            if !isContextPopulated {
                populateModelContext()
            }
        }
        .task {
            print(lastVersionLoadedNewLocations)
            if lastVersionLoadedNewLocations != currentVersion {
                do {
                    try await loadNewLocations()
                } catch {
                    print("Error: loadNewLocations(): \(error.localizedDescription)")
                }
            }
        }
    }
    
    func loadNewLocations() async throws {
        let newLocations: [NewLocation] = try await FirebaseService.shared.fetchData(ref: Collections.newLocations)

        try newLocations.forEach { location in
            let newLocation = Location(
                id: location.id,
                name: location.name,
                country: location.country,
                city: location.city,
                state: location.state,
                detail: location.detail,
                longitude: location.longitude,
                latitude: location.latitude,
                cityLongitude: location.cityLongitude,
                cityLatitude: location.cityLatitude,
                stateAbbrev: location.stateAbbrev,
                imageUrl: location.imageUrl,
                geohash: location.geohash
            )
            
            let fetchDescriptor = FetchDescriptor<Location>(predicate: #Predicate<Location> { modelLocation in
                modelLocation.id == location.id
            })
            
            let locationsWithId = try modelContext.fetch(fetchDescriptor)
            print(locationsWithId)
            
            if locationsWithId.isEmpty {
                modelContext.insert(newLocation)
            }
        }
        lastVersionLoadedNewLocations = currentVersion
    }
    
    func populateModelContext() {
        let locations = Bundle.main.decode(file: "locationData.json")
        
        locations.forEach { location in
            let newLocation = Location(
                id: location.id,
                name: location.name,
                country: location.country,
                city: location.city,
                state: location.state,
                detail: location.detail,
                longitude: location.longitude,
                latitude: location.latitude,
                cityLongitude: location.cityLongitude,
                cityLatitude: location.cityLatitude,
                stateAbbrev: location.stateAbbrev,
                imageUrl: location.imageUrl,
                geohash: location.geohash
            )
            
            modelContext.insert(newLocation)
        }
        isContextPopulated = true
    }
    
    func wipeModelContext() {
        do {
            try modelContext.delete(model: Location.self)
        } catch {
            fatalError("Error: wipeModelContext(): \(error.localizedDescription)")
        }
    }
}

#Preview {
    ContentView()
}
