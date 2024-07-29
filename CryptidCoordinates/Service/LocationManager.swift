//
//  LocationManager.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 2/11/24.
//

import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    @Published var lastKnownLocation: CLLocationCoordinate2D?

    override init() {
        super.init()
        manager.delegate = self
    }

    func start() {
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastKnownLocation = locations.first?.coordinate
    }
    
        private func geohashNeighbors(cords: CLLocationCoordinate2D) -> [Geohash.Hash] {
            let geohash = Geohash(coordinates: (cords.latitude, cords.longitude), precision: 4)
    
            guard let currentGeohash = geohash?.geohash else { return [] }
            guard var neighbors = geohash?.neighbors?.all.compactMap( { $0.geohash }) else { return [] }
            neighbors.append(currentGeohash)
    
            return neighbors
        }
    
    var geohashes: [String] {
        guard let lastKnownLocation = lastKnownLocation else { return [] }
        
        let geohash = Geohash(coordinates: (lastKnownLocation.latitude, lastKnownLocation.longitude), precision: 4)
        
        guard let currentGeohash = geohash?.geohash else { return [] }
        guard var neighbors = geohash?.neighbors?.all.compactMap( { $0.geohash }) else { return [] }
        neighbors.append(currentGeohash)
        
        return neighbors
    }
}
