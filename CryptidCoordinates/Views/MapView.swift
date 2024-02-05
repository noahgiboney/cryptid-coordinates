import MapKit
import SwiftUI

struct MapView: View {
    
    @State private var clusterManager = ClusterMap()
    @State private var viewModel = ViewModel()

    var body: some View {
        NavigationStack{
            ZStack(alignment: .bottom){
                
                mapLayer

                if viewModel.selectedLocation != nil{
                    if let selectedLocation = viewModel.selectedLocation {
                        PreviewView(cameraPosition: $viewModel.cameraPosition, currentLocation: selectedLocation)
                            .overlay {
                                Button {
                                    viewModel.selectedLocation = nil
                                    viewModel.updateCamera(to: selectedLocation.coordinates, span: 0.05)
                                }label: {
                                    Image(systemName: "arrow.down.right.and.arrow.up.left")
                                        .darkButtonStyle(foreground: .red)
                                }
                                .font(.caption)
                                .padding(.top, 165)
                                .padding(.leading, 290)
                            }
                    }
                }
            }
            .navigationTitle("Crytpid Coordinates")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .topBarTrailing){
                    Button {
                        viewModel.showingSearch.toggle()
                    } label: {
                        Image(systemName: "magnifyingglass.circle")
                    }
                }
                ToolbarItem(placement: .topBarLeading){
                    Button {
                        viewModel.showingUserFavorites.toggle()
                    } label: {
                        Image(systemName: "star.circle")
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
            }
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
                                print("tapped cluster")
                                viewModel.updateCamera(to: item.coordinate, span: 0.05)
                            }
                    }
                }
                .annotationTitles(.hidden)
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
