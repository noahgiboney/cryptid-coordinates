import MapKit
import SwiftUI

struct MapView: View {
    
    @State private var clusterManager = ClusterMap()
    @State private var viewModel = ViewModel()

    var body: some View {
        ZStack(alignment: .bottom){
            
            mapLayer

            if viewModel.selectedLocation == nil{
                buttonLayer
            }
            else{
                if let selectedLocation = viewModel.selectedLocation {
                    PreviewView(cameraPosition: $viewModel.cameraPosition, currentLocation: selectedLocation)
                }
            }
        }
        .preferredColorScheme(.light)
        .sheet(isPresented: $viewModel.showingSearch) {
            SearchListView(cameraPosition: $viewModel.cameraPosition)
                .presentationDetents([.fraction(0.25),.medium,.large])
        }
        .sheet(isPresented: $viewModel.showingUserFavorites) {
            SavedLocationsView()
        }
    }
}

#Preview {
    MapView()
}

extension MapView {
    
    private var mapLayer: some View {
        MapReader{ reader in
            Map(position: $viewModel.cameraPosition) {
                ForEach(clusterManager.annotations) { item in
                    
                    Annotation("\(item.id)", coordinate: item.coordinate) {
                        MapAnnotationView()
                            .scaleEffect(viewModel.selectedLocation?.coordinates == item.coordinate ? 1.3 : 1)
                            .onTapGesture {
                                viewModel.tappedMarker(marker: item)
                            }
                    }
                    .annotationTitles(.hidden)
                }
                ForEach(clusterManager.clusters) { item in
                    Annotation("\(item.count)", coordinate: item.coordinate) {
                        MapClusterView()
                            .onTapGesture {
                                viewModel.updateCamera(to: item.coordinate, span: 0.03)
                            }
                    }
                }
                .annotationTitles(.hidden)
            }
            .onTapGesture(perform: { screenCord in
                if let tappedCord = reader.convert(screenCord, from: .local) {
                    if !clusterManager.isAMarker(point: tappedCord) && viewModel.selectedLocation != nil{
                        viewModel.selectedLocation = nil
                        
                        if let spanLat = viewModel.cameraPosition.region?.span.latitudeDelta, let currentCord = viewModel.cameraPosition.region?.center {
                            viewModel.updateCamera(to: currentCord, span: spanLat + 0.05)
                        }
                    }
                }
            })
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
    
    private var buttonLayer: some View {
        HStack{
            Button {
                viewModel.showingUserFavorites.toggle()
            } label: {
                Image(systemName: "star.fill")
                    .navButtonStyle()
            }
            .padding()
            
            Button {
                viewModel.showingSearch.toggle()
            } label: {
                Image(systemName: "magnifyingglass")
                    .navButtonStyle()
            }
            .padding()
        }
        .padding(.bottom)
    }
}
