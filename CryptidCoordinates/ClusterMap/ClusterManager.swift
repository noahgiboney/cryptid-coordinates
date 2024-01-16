//
//  LocalSearchCompleter.swift
//  Example-SwiftUI
//
//  Created by Mikhail Vospennikov on 21.10.2023.
//

import ClusterMap
import Foundation
import MapKit

extension MapView {
    struct ExampleClusterAnnotation: Identifiable {
        var id = UUID()
        var coordinate: CLLocationCoordinate2D
        var count: Int
    }
    
    @Observable
    class ClusterMap: NSObject, MKLocalSearchCompleterDelegate {
        private let clusterManager = ClusterManager<MKMapItem>()
        
        var mapSize: CGSize = .zero
        var currentRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.787_994, longitude: -122.407_437),
                                               span: .init(latitudeDelta: 0.1, longitudeDelta: 0.1))
        var annotations = [MKMapItem]()
        var clusters = [ExampleClusterAnnotation]()
        
        func getAnnotations(center: CLLocationCoordinate2D) async {
            let filteredLocations = HauntedLocation.allLocations.filter { location in
                guard let longitude = Double(location.longitude), let latitude = Double(location.latitude) else {
                    return false
                }
                
                let lowerBoundLong = longitude - 2
                let upperBoundLong = longitude + 2
                
                let lowerBoundLat = latitude - 2
                let upperBoundLat = latitude + 2
                
                return center.longitude >= lowerBoundLong && center.longitude <= upperBoundLong &&
                center.latitude >= lowerBoundLat && center.latitude <= upperBoundLat
            }
            
            let annotations = filteredLocations.map { location in
                MKMapItem(placemark: MKPlacemark(coordinate: location.coordinates))
            }
            
            await clusterManager.removeAll()
            await clusterManager.add(annotations)
            await reloadAnnotations()
        }
        
        func reloadAnnotations() async {
            async let changes = clusterManager.reload(mapViewSize: mapSize, coordinateRegion: currentRegion)
            await applyChanges(changes)
        }
        
        @MainActor
        private func applyChanges(_ difference: ClusterManager<MKMapItem>.Difference) {
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
                    clusters.append(ExampleClusterAnnotation(
                        id: newItem.id,
                        coordinate: newItem.coordinate,
                        count: newItem.memberAnnotations.count
                    ))
                }
            }
        }
    }
}
    
extension MKMapItem: CoordinateIdentifiable, Identifiable {
    public var id: String {
        placemark.region?.identifier ?? UUID().uuidString
    }
    
    public var coordinate: CLLocationCoordinate2D {
        get { placemark.coordinate }
        set(newValue) { }
    }
}
    
