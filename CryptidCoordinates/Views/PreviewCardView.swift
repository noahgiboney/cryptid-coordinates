//
//  PreviewView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 1/18/24.
//

import MapKit
import SwiftUI

struct PreviewCardView: View {
    
    @Binding var cameraPosition: MapCameraPosition
    @State private var path = [HauntedLocation]()

    var location: HauntedLocation
    
    var body: some View {
        VStack(){
            Spacer()
            locationCard
                .padding(.bottom, 100)
        }
        .navigationTitle("\(location.name)")
        .navigationDestination(for: HauntedLocation.self) { location in
            LocationDetailView(location: location)
        }
    }
}

#Preview {
    PreviewCardView(cameraPosition: .constant(.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.787994, longitude: -122.407437), span: .init(latitudeDelta: 0.1, longitudeDelta: 0.1)))) ,location : HauntedLocation.allLocations[33])
}

extension PreviewCardView {
    
    private var locationCard: some View {
        NavigationStack(path: $path){
            VStack(spacing: 10){
                Text(location.name)
                    .font(.title.bold())
                Text(location.cityState)
                    .font(.subheadline)
                    .padding(.bottom)
                Button{
                    path.append(location)
                } label: {
                    Label("Investigate", systemImage: "eye")
                        .darkButtonStyle(foreground: .blue)
                }
            }
            .frame(width: 300, height: 150)
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(.rect(cornerRadius: 15))
            .shadow(radius: 5)
        }
        
    }
}
