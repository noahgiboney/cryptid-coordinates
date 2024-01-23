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
    @State private var pickerSel = 0
    
    var body: some View {
        NavigationStack{
            
            VStack{
                if viewModel.searchText != ""{
                    List(viewModel.searchList, id: \.self) { cityName in
                        Text(cityName)
                            .onTapGesture {
                                updateCamera(to: viewModel.getCordFor(for: cityName), span: 0.15)
                                dismiss()
                            }
                    }
                    .id(UUID())
                }
            }
            
            //navigation
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search for a city")
            .toolbar {
                ToolbarItem{
                    Menu("Search by", systemImage: "arrow.up.arrow.down") {
                        Picker("Search by", selection: $pickerSel) {
                            Text("City")
                            Text("Location")
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
