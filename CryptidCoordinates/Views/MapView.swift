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
                    .background(Color.black.opacity(0.7))
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
        .sheet(item: $viewModel.selectedLocation){ location in
            if let location = viewModel.selectedLocation {
                LocationDetailView(location: location)
            }
        }
    }
}

#Preview {
    MapView()
}
