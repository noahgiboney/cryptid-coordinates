//
//  HauntedCitiesListView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 1/13/24.
//

import SwiftUI
import MapKit

struct SearchListView: View {
    
    @AppStorage("searchType") var searchBy: SearchType = .city
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
            // nav
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $viewModel.showingDetails){
                if let location = viewModel.location{
                    LocationDetailView(location: location)
                }
            }
            .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search for a \(searchBy.rawValue)")
            // toolbar
            .toolbar {
                ToolbarItem(placement: .topBarLeading){
                    Button("Close"){
                        dismiss()
                    }
                }
                ToolbarItem{
                    Menu("Search by", systemImage: "line.3.horizontal.decrease.circle") {
                        Picker("Search by", selection: $searchBy) {
                            Text("City")
                                .tag(SearchType.city)
                            Text("Location")
                                .tag(SearchType.location)
                        }
                    }
                    
                }
            }
            .onChange(of: searchBy){
                viewModel.searchSelection = searchBy
            }
            .onAppear {
                viewModel.searchSelection = searchBy
            }
        }
    }
    
    // update map camera to some point
    func updateCamera(to point: CLLocationCoordinate2D, span: Double) {
        withAnimation(.smooth(duration: 1.5)){
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
            Text(item.text + " " + (item.cityState ?? ""))
                .onTapGesture {
                    switch searchBy {
                    case .city:
                        updateCamera(to: viewModel.getCordFor(for: item), span: 0.15)
                        dismiss()
                    case .location:
                        viewModel.searchItemToLocation(item: item)
                        viewModel.showingDetails.toggle()
                    }
                    
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
