import MapKit
import SwiftUI

struct MapView: View {
    @State private var clusterManager = ClusterMap()
    @State private var viewModel = ViewModel()

    var body: some View {
        ZStack(alignment: .top){
            Map(initialPosition: .region(clusterManager.currentRegion)) {
                ForEach(clusterManager.annotations) { item in
                    
                    Annotation("\(item.id)", coordinate: item.coordinate) {
                        MapAnnotationView()
                            .onTapGesture {
                                clusterManager.getSelectedLocation(item)
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
            Button {
                viewModel.showingSearch.toggle()
            } label: {
                Image(systemName: "magnifyingglass")
                    .frame(width: 50, height: 50)
                    .background(Color.black.opacity(0.8))
                    .clipShape(Circle())
            }
            .padding()
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
        .sheet(item: $clusterManager.selectedLocation){ location in
            if let location = clusterManager.selectedLocation {
                let nearestLocations = viewModel.getNearestLocations(for: location)
                LocationPreviewView(nearestLocations: nearestLocations)
                    .presentationDetents([.fraction(0.25)])
            }
        }
    }
}

#Preview {
    MapView()
}
