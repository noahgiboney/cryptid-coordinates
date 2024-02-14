//
//  ClusterManager.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 1/17/24.
//

import ClusterMap
import Foundation
import MapKit
import SwiftUI


extension MapView {
    struct ExampleClusterAnnotation: Identifiable {
        var id = UUID()
        var coordinate: CLLocationCoordinate2D
        var count: Int
    }

    @Observable
    class LocationClusterManager: NSObject, MKLocalSearchCompleterDelegate {
        private let completer = MKLocalSearchCompleter()
        private let clusterManager = ClusterManager<MKMapItem>()

        var mapSize: CGSize = .zero
        var currentRegion: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 33, longitude: -122), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        var annotations = [MKMapItem]()
        var clusters = [ExampleClusterAnnotation]()

        func setup() {
            completer.delegate = self
        }

        
        func loadLocations() async {
            
            var arr = [MKMapItem]()
            
            for location in HauntedLocation.allLocations {
                arr.append(MKMapItem(placemark: MKPlacemark(coordinate: location.coordinates)))
            }
            
            await clusterManager.removeAll()
            await clusterManager.add(arr)
            await reloadAnnotations()
            
        }
    
        func reloadAnnotations() async {
            async let changes = clusterManager.reload(mapViewSize: mapSize, coordinateRegion: currentRegion)
            await applyChanges(changes)
        }
        
        func zoomIn(to point: CLLocationCoordinate2D, span: Double) {
            withAnimation(.smooth(duration: 1.5)){
                currentRegion = MKCoordinateRegion(center: point, span: MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span))
            }
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

