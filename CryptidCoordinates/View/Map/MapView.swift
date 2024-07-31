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

struct MapView: View {
    var defaultCords: CLLocationCoordinate2D
    @Environment(GlobalModel.self) var global
    @Environment(\.modelContext) var modelContext
    @State private var selectedLocation: Location?
    @State private var model: MapModel
    @State private var cameraPosition: MapCameraPosition
    @State private var didLoadAnnotations = false
    @Query var locations: [Location]
    
    init(defaultCords: CLLocationCoordinate2D) {
        self.defaultCords = defaultCords
        let defaultRegion = MKCoordinateRegion(center: defaultCords, span: MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.15))
        let mapModel = MapModel(defaultRegion: defaultRegion)
        
        self._cameraPosition = State(initialValue: .region(defaultRegion))
        self._model = State(initialValue: mapModel)
    }
    
    var body: some View {
        GeometryReader { proxy in
            Map(position: $cameraPosition, interactionModes: .all) {
                UserAnnotation()
                
                ForEach(model.annotations) { annotation in
                    let location = annotation.location
                    Annotation("", coordinate: location.coordinates) {
                        AnnotationView(url: location.url)
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
            .onChange(of: global.selectedLocation) { oldValue, newValue in
                if let location = global.selectedLocation {
                    goToSelectedLocation(location)
                }
            }
            .sheet(item: $selectedLocation) { location in
                NavigationStack {
                    LocationView(location: location)
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
            .task {
                guard !didLoadAnnotations else { return }
                await model.addAnnotations(locations: locations)
                didLoadAnnotations = true
            }
        }
    }

    func goToSelectedLocation(_ location: Location) {
        cameraPosition = location.cameraPosition
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation {
                cameraPosition = .region(MKCoordinateRegion(center: location.coordinates, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)))
            }
        }
    }
}

#Preview {
    MapView(defaultCords: Location.example.coordinates)
        .environment(GlobalModel(user: .example))
        .environmentObject(LocationManager())
}
