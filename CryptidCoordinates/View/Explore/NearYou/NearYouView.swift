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
    @Query var nearLocations: [Location]
    
    init(geohashes: [String]) {
        self.geohashes = geohashes
        
        _nearLocations = .init(filter: #Predicate<Location> { location in
            return geohashes.contains(location.geohash)
        })
    }
    
    var body: some View {
        ExploreTabContainer(title: "Near You", description: "Huanted Locations Near You") {
            if locationManager.lastKnownLocation == nil && !locationManager.isLoadingLocation {
                LocationUnavailableView(message: "Share your location to explore in your vicinity")
            } else {
                NearYouScrollView(locations: nearLocations, cords: locationManager.lastKnownLocation!)
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
