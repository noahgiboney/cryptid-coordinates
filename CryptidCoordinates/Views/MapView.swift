import MapKit
import SwiftUI

struct MapView: View {
    @State private var clusterManager = ClusterMap()
    @State private var viewModel = ViewModel()

    var body: some View {
        ZStack{
            Map(position: $viewModel.cameraPosition) {
                ForEach(clusterManager.annotations) { item in
                    
                    Annotation("\(item.id)", coordinate: item.coordinate) {
                        MapAnnotationView()
                            .scaleEffect(viewModel.selectedLocation?.coordinates == item.coordinate ? 1.5 : 1)
                            .onTapGesture {
                                viewModel.selectedLocation = viewModel.getLocation(for: item)
//                                viewModel.showingPreview.toggle()
                            }
                    }
                    .annotationTitles(.hidden)
                }
                ForEach(clusterManager.clusters) { item in
                    Annotation("\(item.count)", coordinate: item.coordinate) {
                        MapClusterView()
                    }
        
                }
            }
                if let selectedLocation = viewModel.selectedLocation {
                    
                    let nearestLocations = viewModel.getNearestLocations(for: selectedLocation)
                    
                    PreviewView(cameraPosition: $viewModel.cameraPosition, selectedLocation: $viewModel.selectedLocation, nearestLocations: nearestLocations)
                }
            
            
 
            
//            Button {
//                viewModel.showingSearch.toggle()
//            } label: {
//                Image(systemName: "magnifyingglass")
//                    .frame(width: 50, height: 50)
//                    .background(Color.black.opacity(0.8))
//                    .clipShape(Circle())
//            }
//            .padding()
        }
        // map
        .mapStyle(.hybrid)
        .onMapCameraChange { context in
            clusterManager.currentRegion = context.region
            Task.detached {
                await clusterManager.getAnnotations(center: clusterManager.currentRegion.center)
                await clusterManager.reloadAnnotations()
            }
        }
        .readSize(onChange: { newValue in
            clusterManager.mapSize = newValue
        })
        .sheet(isPresented: $viewModel.showingSearch) {
            SearchListView(cameraPosition: $viewModel.cameraPosition)
        }
        // location detail view
        .sheet(isPresented: $viewModel.showingPreview ) {
            if let selectedLocation = viewModel.selectedLocation {
                let nearestLocations = viewModel.getNearestLocations(for: selectedLocation)
                LocationPreviewView(cameraPosition: $viewModel.cameraPosition, selectedLocation: $viewModel.selectedLocation, nearestLocations: nearestLocations)
                    .presentationDetents([.fraction(0.4)])
                    .onDisappear {
                        viewModel.selectedLocation = nil
                    }
            }
        }
    }
}

#Preview {
    MapView()
}
