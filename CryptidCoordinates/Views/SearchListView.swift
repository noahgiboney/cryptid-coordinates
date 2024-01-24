//
//  HauntedCitiesListView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 1/13/24.
//

import SwiftUI
import MapKit

struct SearchListView: View {
    
    @Environment(\.dismiss) var dismiss
    @Binding var cameraPosition: MapCameraPosition
    @State private var viewModel = ViewModel()
    
    var body: some View {
        NavigationStack{
            
            VStack{
                if viewModel.searchText != ""{
                    searchList
                }
                else {
                    placeholderImage
                }
            }
            
            //navigation
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search for a \(viewModel.searchSelection.rawValue)")
            .toolbar {
                ToolbarItem{
                    Menu("Search by", systemImage: "arrow.up.arrow.down") {
                        Picker("Search by", selection: $viewModel.searchSelection) {
                            Text("City")
                                .tag(ListType.city)
                            Text("Location")
                                .tag(ListType.location)
                        }
                    }
                }
            }
        }
    }
    
    // update map camera to some point
    func updateCamera(to point: CLLocationCoordinate2D, span: Double) {
        withAnimation(.smooth){
            cameraPosition = .region(MKCoordinateRegion(center: point, span: MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span)))
        }
    }
}

#Preview {
    SearchListView(cameraPosition: .constant(.region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 39.83333, longitude: -98.585522),
        span: MKCoordinateSpan(latitudeDelta: 255, longitudeDelta: 255)))))
}

extension SearchListView {
    
    private var searchList: some View {
        List(viewModel.searchList) { item in
            Text(item.text)
                .onTapGesture {
                    updateCamera(to: viewModel.getCordFor(for: item.text), span: 0.1)
                    dismiss()
                }
        }
        .id(UUID())
    }
    
    private var placeholderImage: some View {
        VStack{
            Image(systemName: "magnifyingglass")
                .resizable()
                .scaledToFit()
                .frame(width: 70)
                .padding(.top)
            Spacer()
        }
    }
}
