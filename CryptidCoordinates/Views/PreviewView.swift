//
//  PreviewView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 1/18/24.
//

import MapKit
import SwiftUI

struct PreviewView: View {
    
    @Binding var cameraPosition: MapCameraPosition
    @State private var showingDetails = false
    
    var currentLocation: HauntedLocation
    
    var body: some View {
        
        VStack(){
            
            
            Spacer()
            
            locationCard
                .padding(.bottom, 100)
        }
        .sheet(isPresented: $showingDetails) {
            LocationDetailView(location: currentLocation)
        }
        .preferredColorScheme(.dark)
    }
    
    
    func updateCamera(to index: Int) {
        withAnimation(.easeIn) {
            cameraPosition = .region(MKCoordinateRegion(center: currentLocation.coordinates, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)))
        }
    }
}

#Preview {
    PreviewView(cameraPosition: .constant(.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.787994, longitude: -122.407437), span: .init(latitudeDelta: 0.1, longitudeDelta: 0.1)))) ,currentLocation : HauntedLocation.allLocations[33])
}

extension PreviewView {
    
    private var locationCard: some View {
        VStack(spacing: 10){
            Label(currentLocation.name, systemImage: "mappin")
                .font(.title.bold())
            
            Text(currentLocation.cityState)
                .font(.subheadline)
                .padding(.bottom)
            
            Button{
                showingDetails.toggle()
            } label: {
                Label("Investigate", systemImage: "eye.fill")
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
