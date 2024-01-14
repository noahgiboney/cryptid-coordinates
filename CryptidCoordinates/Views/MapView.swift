//
//  MapView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 1/9/24.
//
import MapKit
import SwiftUI

struct MapView: View {
    
    @State private var viewModel = ViewModel()
    
    var body: some View {
        NavigationStack{
            ZStack(alignment: .topTrailing){
                Map(position: $viewModel.cameraPosition){
                    UserAnnotation()
                    ForEach(HauntedLocation.locations.filter({ location in
                        location.city == "Los Angeles"
                    })) { location in
                        Annotation(location.name, coordinate: location.coordinates) {
                            Image(systemName: "eye")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 44, height: 44)
                                .background(.white)
                                .clipShape(.capsule)
                                .onTapGesture(perform: {
                                    viewModel.updateSelectedLocation(location: location)
                                })
                        }
                    }
                }
                Button {
                    
                } label: {
                    Image(systemName: "magnifyingglass")
                        .frame(width: 44, height: 44)
                        .background(Color.black.opacity(0.7))
                        .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                }
                .padding(.trailing)
            }
            // map
            .mapStyle(.hybrid)
            .tint(Color.green)
            .onAppear {
                viewModel.checkIfLocationsEnabled()
            }
            // city search view
            
            // location detail view
            .sheet(item: $viewModel.selectedLocation){ location in
                if let location = viewModel.selectedLocation {
                    LocationDetailView(location: location)
                }
            }
        }
    }
}

#Preview {
    MapView()
}
