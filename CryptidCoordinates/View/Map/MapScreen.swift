//
//  MapView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/14/24.
//

import ClusterMapSwiftUI
import MapKit
import SwiftData
import SwiftUI

struct MapScreen: View {
    var defaultCords: CLLocationCoordinate2D
    @EnvironmentObject var locationManager: LocationManager
    @Environment(GlobalModel.self) var global
    @Environment(\.modelContext) var modelContext
    @State private var selectedLocation: Location?
    @State private var model: MapModel
    @State private var didLoadAnnotations = false
    @State private var didAppear = false
    @Query var locations: [Location]
    
    init(defaultCords: CLLocationCoordinate2D) {
        self.defaultCords = defaultCords
        let defaultRegion = MKCoordinateRegion(center: defaultCords, span: MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.15))
        let mapModel = MapModel(defaultRegion: defaultRegion)
        self._model = State(initialValue: mapModel)
    }
    
    var body: some View {
        GeometryReader { proxy in
            Map(position: Bindable(global).cameraPosition, interactionModes: .all) {
                UserAnnotation()
                
                ForEach(model.annotations) { annotation in
                    let location = annotation.location
                    Annotation("", coordinate: location.coordinates) {
                        MapAnnotationView(url: location.url)
                            .onTapGesture {
                                selectedLocation = location
                            }                            
                    }
                }
                
                ForEach(model.clusters) { cluster in
                    Marker(
                        "\(cluster.count)",
                        systemImage: "square.3.layers.3d",
                        coordinate: cluster.coordinate
                    )
                    .tint(.black)
                }
            }
            .mapStyle(.hybrid)
            .mapControls {
                MapUserLocationButton()
            }
            .onMapCameraChange { context in
                model.currentRegion = context.region
            }
            .onMapCameraChange(frequency: .onEnd, {
                Task.detached { await model.reloadAnnotations() }
            })
            .readSize(onChange: { newValue in
                model.mapSize = newValue
            })
            .sheet(item: $selectedLocation) { location in
                NavigationStack {
                    LocationScreen(location: location)
                        .overlay(alignment: .topTrailing) {
                            Button {
                                selectedLocation = nil
                            } label: {
                                Image(systemName: "xmark")
                                    .padding(10)
                                    .background(.ultraThinMaterial, in: Circle())
                                    .padding()
                            }
                        }
                }
            }
        }
        .onAppear {
            if !didAppear && global.selectedLocation == nil {
                if let userLocation = locationManager.lastKnownLocation {
                    global.cameraPosition = .region(MKCoordinateRegion(center: userLocation, span: MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.15)))
                }
            }
            didAppear = true
        }
        .task {
            guard !didLoadAnnotations else { return }
            await model.addAnnotations(locations: locations)
            didLoadAnnotations = true
        }
    }
}

#Preview {
    MapScreen(defaultCords: Location.example.coordinates)
        .environment(GlobalModel(user: .example, defaultCords: Location.example.coordinates))
        .environmentObject(LocationManager())
}
