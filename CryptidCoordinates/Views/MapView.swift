//
//  MapView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 1/9/24.
//

import MapKit
import SwiftUI

struct MapView: View {
    
    @State private var cluserManager = LocationClusterManager()
    @State private var viewModel = ViewModel()
    
    let locationFetcher = LocationFetcher()
    
    var body: some View {
        
        ZStack(alignment: .topLeading){
            
            mapLayer
            
            if viewModel.selectedLocation != nil{
                
                HStack{
                    
                    Spacer()
                    
                    previewLayer
                    
                    Spacer()
                }
            }
            
        }
        .preferredColorScheme(.dark)
        .sheet(isPresented: $viewModel.showingSearch) {
            SearchListView(cameraPosition: $viewModel.cameraPosition)
                .presentationDetents([.fraction(0.25),.medium,.large])
        }
        .sheet(isPresented: $viewModel.showingUserFavorites) {
            SavedLocationsView()
                .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    MapView()
}

extension MapView {
    
    private var previewLayer: some View {
        VStack{
            
            if let selectedLocation = viewModel.selectedLocation {
                
                PreviewCardView(cameraPosition: $viewModel.cameraPosition, location: selectedLocation)
                    .overlay(alignment: .bottom){
                        
                        Button {
                            viewModel.selectedLocation = nil
                            viewModel.updateCamera(to: selectedLocation.coordinates, span: 0.08)
                        }label: {
                            Image(systemName: "arrow.down.left.arrow.up.right")
                                .foregroundStyle(.red)
                        }
                        .font(.title3)
                        .padding(.bottom, 245)
                        .padding(.leading, 305)
                    }
            }
        }
    }
    
    
    private var mapLayer: some View {
        
        Map(
            position: $viewModel.cameraPosition,
            interactionModes: .all
        ) {
            
            UserAnnotation()
            
            ForEach(cluserManager.annotations) { item in
                
                Annotation(item.id, coordinate: item.coordinate) {
                    MapAnnotationView(image: "ghoul")
                        .scaleEffect(viewModel.selectedLocation?.coordinates == item.coordinate ? 1.3 : 1)
                        .onTapGesture {
                            viewModel.updateCamera(to: item.coordinate, span: 0.01)
                            viewModel.tappedMarker(marker: item)
                        }
                }
                .annotationTitles(.hidden)
            }
            
            ForEach(cluserManager.clusters) { item in
                
                Annotation("\(item.count)", coordinate: item.coordinate) {
                    MapAnnotationView(image: "square.3.layers.3d")
                        .onTapGesture {
                            viewModel.updateCamera(to: item.coordinate, span: 0.08)
                        }
                }
            }
        }
        .overlay(alignment: .bottom, content: {
            
            HStack{
                
                Button{
                    viewModel.showingUserFavorites.toggle()
                } label: {
                    Label("Favorites", systemImage: "star.fill")
                        .darkLabelStyle(foreground: .yellow)
                }
                
                Button{
                    viewModel.showingSearch.toggle()
                } label: {
                    Label("Search", systemImage: "magnifyingglass")
                        .darkLabelStyle(foreground: .blue)
                }
            }
            
        })
        .mapControls{
            
            if locationFetcher.lastKnownLocation != nil {
                MapUserLocationButton()
            }
            
            MapPitchToggle()
        }
        .readSize(onChange: { newValue in
            cluserManager.mapSize = newValue
        })
        .onMapCameraChange { context in
            cluserManager.currentRegion = context.region
        }
        .onMapCameraChange(frequency: .onEnd) { context in
                        
            if context.region.span.latitudeDelta < 7.0 && context.region.span.longitudeDelta < 7.0 {
                Task.detached { await cluserManager.reloadAnnotations() }
            }
        }
        .onAppear {
            cluserManager.setup()
            locationFetcher.start()
            Task.detached {
                await cluserManager.loadLocations()
            }
            
        }
        .onChange(of: locationFetcher.lastKnownLocation) {
            if !viewModel.userLocationUpdated{
                if let location = locationFetcher.lastKnownLocation {
                    viewModel.cameraPosition = .region(MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)))
                }
                viewModel.userLocationUpdated = true
            }
        }
    }
}

