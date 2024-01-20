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
            header
                .padding(.top, 40)
            
            Spacer()
            
            locationCard
                .padding(.bottom, 50)
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
    
    private var header: some View {
        Label(nearestLocations[index].location, systemImage: "mappin")
            .font(.title2.bold())
            .padding(.horizontal, 30)
            .frame(height: 50)
            .background(.ultraThinMaterial)
            .clipShape(.rect(cornerRadius: 10))
            .shadow(radius: 10)
    }
    
    private var locationCard: some View {
        VStack(spacing: 5){
            Spacer()
            AsyncImage(url: URL(string: imageManager.queryURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: 120)
                    .clipped()
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )
            } placeholder: {
                HStack {
                    ProgressView()
                }
            }
            
                Spacer()
            
                Button{
                    showingDetails.toggle()
                } label: {
                    Image(systemName: "waveform.badge.magnifyingglass")
                    Text("Investigate")
                        .padding(5)
                }
                .buttonStyle(.borderedProminent)
            
            
            HStack{
                if nearestLocations[index] != nearestLocations.first{
                    Button {
                        moveLeft()
                    } label: {
                        Image(systemName: "arrow.left")
                    }
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
        .frame(width: 300, height: 200)
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(.rect(cornerRadius: 15))
        .shadow(radius: 5)
    }
    
}
