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
    @Binding var selectedLocation: HauntedLocation?
    @State private var imageManager = GoogleAPIManager()
    @State private var showingDetails = false
    @State private var index = 0
    let nearestLocations: [HauntedLocation]
    
    var body: some View {
        
        VStack(){
            
            Spacer()
            
            locationCard
                .padding(.bottom, 100)
        }
        .sheet(isPresented: $showingDetails, content: {LocationDetailView(location: nearestLocations[index])})
    }
    
    func moveRight() {
        index += 1
        updateCamera(to: index)
        selectedLocation = nearestLocations[index]
    }
    
    func moveLeft() {
        index -= 1
        updateCamera(to: index)
        selectedLocation = nearestLocations[index]
    }
    
    func updateCamera(to index: Int) {
        withAnimation(.easeIn) {
            cameraPosition = .region(MKCoordinateRegion(center: nearestLocations[index].coordinates, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)))
        }
    }
}

#Preview {
    PreviewView(cameraPosition: .constant(.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.787994, longitude: -122.407437), span: .init(latitudeDelta: 0.1, longitudeDelta: 0.1)))) ,selectedLocation: .constant(nil)  ,nearestLocations: [HauntedLocation.example, HauntedLocation.allLocations[1]])
}

extension PreviewView {
    
    private var locationCard: some View {
        VStack(spacing: 5){
            
            Label(nearestLocations[index].location, systemImage: "mappin")
                .font(.title.bold())
            
            Spacer()
            
            Button{
                showingDetails.toggle()
            } label: {
                Label("Investigate", systemImage: "eye.fill")
            }
            .previewButtomStyle()
            
            HStack{
                if nearestLocations[index] != nearestLocations.first{
                    Button {
                        moveLeft()
                    } label: {
                        Image(systemName: "arrow.left")
                    }
                    .previewButtomStyle()
                }
                else {
                    Spacer()
                }
            
                Spacer()
                
                if nearestLocations[index] != nearestLocations.last{
                    Button {
                        moveRight()
                    } label: {
                        Image(systemName: "arrow.right")
                    }
                    .previewButtomStyle()
                }
                else {
                    Spacer()
                }
            }
            //when index changes and when view is loaded get the image for location
            .task {
                await imageManager.getImage(for: nearestLocations[index].name)
            }
            .onChange(of: selectedLocation) {
                Task {
                    await imageManager.getImage(for: (nearestLocations[index].name))
                }
            }
        
        }
        .frame(width: 300, height: 175)
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(.rect(cornerRadius: 15))
        .shadow(radius: 5)
    }
    
}
