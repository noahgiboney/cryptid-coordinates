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
    @State private var viewModel = ViewModel()
    @Binding var cameraPosition: MapCameraPosition
    
    var body: some View {
        NavigationStack{
            ZStack{
                List(viewModel.searchList, id: \.self) { cityName in
                    Text(cityName)
                        .onTapGesture {
                            cameraPosition = viewModel.getCityCameraPosition(for: cityName)
                            dismiss()
                        }
                }
            }
            //navigation
            .navigationTitle("Cryptid Locations")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search for a city")
            //toobar
            .toolbar{
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    SearchListView(cameraPosition: .constant(.region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 39.83333, longitude: -98.585522),
        span: MKCoordinateSpan(latitudeDelta: 255, longitudeDelta: 255)))))
}
