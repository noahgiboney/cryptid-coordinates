//
//  PreviewView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 1/18/24.
//

import MapKit
import StoreKit
import SwiftUI

struct PreviewCardView: View {
    
    @AppStorage("visitCount") var visitCount = 0
    @Environment(\.requestReview) var requestReview
    @Binding var cameraPosition: MapCameraPosition
    @State private var showingDetails = false
    
    // current locaiton to display
    var location: Locations
    
    var body: some View {
        
        VStack(){
            
            Spacer()
            
            locationCard
                .padding(.bottom, 80)
        }
        .sheet(isPresented: $showingDetails){
            LocationDetailView(location: location)
        }
    }
    
    @MainActor
    func requestReviewIfAppropriate(){
        if visitCount <= 8{
            visitCount += 1
        }
        
        if visitCount == 8 {
            requestReview()
        }
    }
}

#Preview {
    PreviewCardView(cameraPosition: .constant(.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.787994, longitude: -122.407437), span: .init(latitudeDelta: 0.1, longitudeDelta: 0.1)))) ,location : Locations.allLocations[33])
}

extension PreviewCardView {
    
    private var locationCard: some View {
        
        VStack(spacing: 10){
            
            Text(location.name)
                .font(.title.bold())
            
            Text(location.cityState)
                .font(.subheadline)
                .padding(.bottom)
            
            Button{
                Task{
                    await requestReviewIfAppropriate()
                }
                print(visitCount)
                showingDetails.toggle()
            } label: {
                Label("Investigate", systemImage: "eye")
                    .darkLabelStyle(foreground: .blue)
            }
        }
        .frame(width: 320, height: 150)
        .padding(.top, 20)
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(.rect(cornerRadius: 15))
        .shadow(radius: 5)
    }
}
