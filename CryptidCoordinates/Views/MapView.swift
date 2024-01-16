//
//  MapKitIntegration.swift
//  Example-SwiftUI
//
//  Created by Mikhail Vospennikov on 17.10.2023.
//

import MapKit
import SwiftUI

struct MapView: View {
    @State private var searchClient = LocalSearchCompleter()
    @State private var viewModel = ViewModel()

    var body: some View {
        ZStack(alignment: .top){
            Map(initialPosition: .region(searchClient.currentRegion)) {
                ForEach(searchClient.annotations) { item in
                    Marker(
                        "\(item.coordinate.latitude) \(item.coordinate.longitude)",
                        systemImage: "mappin",
                        coordinate: item.coordinate
                    )
                    .annotationTitles(.hidden)
                }
                ForEach(searchClient.clusters) { item in
                    Marker(
                        "\(item.count)",
                        systemImage: "square.3.layers.3d",
                        coordinate: item.coordinate
                    )
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
            searchClient.currentRegion = context.region
            Task.detached {
                await searchClient.getAnnotations(center: searchClient.currentRegion.center)
                await searchClient.reloadAnnotations()
            }
        }
        .readSize(onChange: { newValue in
            searchClient.mapSize = newValue
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
