//
//  MapView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 1/9/24.
//

import MapKit
import SwiftUI

struct MapView: View {
    
    
    @State private var clusterManager = ClusterMap()
    @State private var viewModel = ViewModel()
    
    var body: some View {
        NavigationStack{
            ZStack(alignment: .topLeading){
                
                mapLayer
                
                mapButtons
                
                if viewModel.selectedLocation != nil{
                    
                    HStack{
                        
                        Spacer()
                        
                        previewLayer
                        
                        Spacer()
                    }
                }
            }
            .preferredColorScheme(.dark)
            .navigationTitle("Cryptid Coordinates")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $viewModel.showingSearch) {
                SearchListView(cameraPosition: $viewModel.cameraPosition)
                    .presentationDetents([.medium,.large])
            }
            .sheet(isPresented: $viewModel.showingUserFavorites) {
                SavedLocationsView()
                    .navigationBarTitleDisplayMode(.large)
            }
        }
    }
}

#Preview {
    MapView()
}

extension MapView {
    
    private var mapButtons: some View {
        
        VStack(spacing: 1){
            
            Button {
                viewModel.showingUserFavorites.toggle()
            }label: {
                Image(systemName: "star")
                    .darkLabelStyle(foreground: .yellow)
            }
            .scaleEffect(CGSize(width: 0.9, height: 0.9))
            
            Button {
                viewModel.showingSearch.toggle()
            }label: {
                Image(systemName: "magnifyingglass")
                    .darkLabelStyle(foreground: .white)
            }
            .padding(3)
            .scaleEffect(CGSize(width: 0.9, height: 0.9))
            
        }
        .padding(.top, 2)
    }
    
    private var previewLayer: some View {
        
        VStack{
            
            if let selectedLocation = viewModel.selectedLocation {
                
                PreviewCardView(cameraPosition: $viewModel.cameraPosition, location: selectedLocation)
                    .overlay {
                        
                        Button {
                            viewModel.selectedLocation = nil
                            viewModel.updateCamera(to: selectedLocation.coordinates, span: 0.05)
                        }label: {
                            Image(systemName: "arrow.down.left.arrow.up.right")
                                .foregroundStyle(.red)
                        }
                        .font(.title3)
                        .padding(5)
                        .padding(.top, 195)
                        .padding(.leading, 305)
                    }
            }
        }
    }
    
    private var mapLayer: some View {
        
        MapReader{ reader in
            
            Map(position: $viewModel.cameraPosition) {
                
                UserAnnotation()
                
                ForEach(clusterManager.annotations) { item in
                    
                    Annotation("\(item.id)", coordinate: item.coordinate) {
                        
                        MapAnnotationView()
                            .scaleEffect(viewModel.selectedLocation?.coordinates == item.coordinate ? 1.3 : 1)
                            .onTapGesture {
                                viewModel.updateCamera(to: item.coordinate, span: 0.01)
                                viewModel.tappedMarker(marker: item)
                            }
                    }
                    .annotationTitles(.hidden)
                }
                
                ForEach(clusterManager.clusters) { item in
                    
                    Annotation("\(item.count)", coordinate: item.coordinate) {
                        
                        MapClusterView()
                            .onTapGesture {
                                viewModel.updateCamera(to: item.coordinate, span: 0.055)
                            }
                    }
                    .annotationTitles(.hidden)
                }
            }
            .mapControls{
                MapUserLocationButton()
                MapPitchToggle()
            }
            .onAppear{
                CLLocationManager().requestWhenInUseAuthorization()
            }
        }
        .onMapCameraChange { context in
            clusterManager.currentRegion = context.region
            Task {
                await clusterManager.getAnnotations(center: clusterManager.currentRegion.center)
                await clusterManager.reloadAnnotations()
            }
        }
        .readSize(onChange: { newValue in
            clusterManager.mapSize = newValue
        })
    }
}
