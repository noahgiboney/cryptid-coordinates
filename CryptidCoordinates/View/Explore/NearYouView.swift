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
    var geohashes: [String]
    @EnvironmentObject var locationManager: LocationManager
    @Query var nearLocations: [Location]
    
    init(geohashes: [String]) {
        self.geohashes = geohashes
        
        _nearLocations = .init(filter: #Predicate<Location> { location in
            return geohashes.contains(location.geohash)
        })
    }
    
    var sortedLocations: [Location] {
        nearLocations.sorted { location1, location2 in
            let distance1 = locationManager.lastKnownLocation!.distance(from: location1.clLocation)
            let distance2 = locationManager.lastKnownLocation!.distance(from: location2.clLocation)
            
            return distance1 < distance2
        }
    }
    
    var body: some View {
        LocationScrollView(locations: sortedLocations)
            .listRowSeparator(.hidden)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Location.self, configurations: config)
    
    return ExploreView().modelContainer(container)
}
