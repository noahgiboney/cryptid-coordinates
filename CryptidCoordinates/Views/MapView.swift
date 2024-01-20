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
                    let nearestLocations = viewModel.getNearestLocations(for: selectedLocation)
                    
                    PreviewView(cameraPosition: $viewModel.cameraPosition, selectedLocation: $viewModel.selectedLocation, nearestLocations: nearestLocations)
                }
            }
        }
        .preferredColorScheme(.light)
        .sheet(isPresented: $viewModel.showingSearch) {
            SearchListView(cameraPosition: $viewModel.cameraPosition)
                .presentationDetents([.fraction(0.25),.medium,.large])
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
                                viewModel.selectedLocation = viewModel.getLocation(for: item)
                                withAnimation(.easeIn) {
                                    viewModel.cameraPosition = .region(MKCoordinateRegion(center: item.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)))
                                }
                            }
                    }
                    .annotationTitles(.hidden)
                }
                ForEach(clusterManager.clusters) { item in
                    Annotation("\(item.count)", coordinate: item.coordinate) {
                        MapClusterView()
                            .onTapGesture {
                                withAnimation(.easeIn) {
                                    viewModel.cameraPosition = .region(MKCoordinateRegion(center: item.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.04, longitudeDelta: 0.04)))
                                }
                            }
                    }
                }
            }
            .onTapGesture(perform: { tapped in
                
            })
        }
        .mapStyle(.hybrid)
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
                viewModel.showingSearch.toggle()
            } label: {
                Image(systemName: "magnifyingglass")
                    .frame(width: 60, height: 60)
                    .background(Color.black.opacity(0.8))
                    .clipShape(Circle())
            }
            .padding()
            
            Button {
                viewModel.showingSearch.toggle()
            } label: {
                Image(systemName: "star.fill")
                    .frame(width: 60, height: 60)
                    .background(Color.black.opacity(0.8))
                    .clipShape(Circle())
            }
            .padding()
        }
    }
}
