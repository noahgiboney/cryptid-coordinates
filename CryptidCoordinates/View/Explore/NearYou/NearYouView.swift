//
//  NearYouView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 7/21/24.
//

import CoreLocation
import Kingfisher
import SwiftData
import SwiftUI

struct NearYouView: View {
    
    let geohashes: [String]
    @EnvironmentObject var locationManager: LocationManager
    @State private var cachedSortedLocations: [Location] = []
    @State private var lastKnownLocation: CLLocationCoordinate2D?
    @Query var nearLocations: [Location]
    
    let distanceThreshold: CLLocationDistance = 10
    
    init(geohashes: [String]) {
        self.geohashes = geohashes
        
        _nearLocations = .init(filter: #Predicate<Location> { location in
            return geohashes.contains(location.geohash)
        })
    }
    
    private func sortLocations() {
        guard let currentLocation = locationManager.lastKnownLocation else { return }
        
        if let lastLocation = lastKnownLocation {
            let distance = currentLocation.distance(from: CLLocation(latitude: lastLocation.latitude, longitude: lastLocation.longitude ))
            if distance < distanceThreshold {
                return
            }
        }
        
        lastKnownLocation = currentLocation
        
        cachedSortedLocations = nearLocations.sorted { location1, location2 in
            let distance1 = currentLocation.distance(from: location1.clLocation)
            let distance2 = currentLocation.distance(from: location2.clLocation)
            
            return distance1 < distance2
        }
    }
    
    var body: some View {
        ExploreTabContainer(title: "Near You", description: "Locations Near You") {
            if locationManager.lastKnownLocation == nil && !locationManager.isLoadingLocation {
                LocationUnavailableView(message: "Share your location to explore in your vicinity")
            } else {
                VerticalLocationScrollView(locations: Array(cachedSortedLocations.prefix(25)))
                    .onAppear {
                        sortLocations()
                    }
            }
        }
        .listRowSeparator(.hidden)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Location.self, configurations: config)
    
    return ExploreScreen().modelContainer(container)
}
