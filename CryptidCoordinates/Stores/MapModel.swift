//
//  MapModel.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 7/30/24.
//

import ClusterMap
import Foundation
import MapKit

struct LocationAnnotation: CoordinateIdentifiable, Identifiable, Hashable {
    var id = UUID()
    var coordinate: CLLocationCoordinate2D
    var location: Location
}

struct ClusterAnnotation: Identifiable {
    var id = UUID()
    var coordinate: CLLocationCoordinate2D
    var count: Int
}

@Observable
class MapModel {
    let clusterManager = ClusterManager<LocationAnnotation>()
    
    var annotations: [LocationAnnotation] = []
    var clusters: [ClusterAnnotation] = []
    
    var mapSize: CGSize = .zero
    var currentRegion: MKCoordinateRegion
    
    init(defaultRegion: MKCoordinateRegion) {
        self.currentRegion = defaultRegion
    }
    
    func addAnnotations(locations: [Location]) async {
        let newAnnotations = locations.map { LocationAnnotation(coordinate: $0.coordinates, location: $0) }
        await clusterManager.add(newAnnotations)
        await reloadAnnotations()
    }
    
    func reloadAnnotations() async {
        async let changes = clusterManager.reload(mapViewSize: mapSize, coordinateRegion: currentRegion)
        await applyChanges(changes)
    }
    
    @MainActor
    private func applyChanges(_ difference: ClusterManager<LocationAnnotation>.Difference) {
      for removal in difference.removals {
        switch removal {
        case .annotation(let annotation):
          annotations.removeAll { $0 == annotation }
        case .cluster(let clusterAnnotation):
          clusters.removeAll { $0.id == clusterAnnotation.id }
        }
      }
      for insertion in difference.insertions {
        switch insertion {
        case .annotation(let newItem):
          annotations.append(newItem)
        case .cluster(let newItem):
          clusters.append(ClusterAnnotation(
            id: newItem.id,
            coordinate: newItem.coordinate,
            count: newItem.memberAnnotations.count
          ))
        }
      }
    }
}
