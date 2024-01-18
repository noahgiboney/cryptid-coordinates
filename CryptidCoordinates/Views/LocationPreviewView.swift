//
//  LocationPreviewView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 1/16/24.
//

import MapKit
import SwiftUI

struct LocationPreviewView: View {
    
    @Binding var cameraPosition: MapCameraPosition
    @State private var imageManager = GoogleAPIManager()
    @State private var index = 0
    
    var nearestLocations: [HauntedLocation]
        
    var body: some View {
        VStack{
            
            HStack{
                VStack(alignment: .leading, spacing: 8){
                    Text(nearestLocations[index].name)
                        .font(.title.bold())
                        
                    Text("\(nearestLocations[index].city), USA")
                        .font(.subheadline.italic())
                }

                Spacer()
            }
            .padding(.vertical)
            
            
            
            HStack{
                
                AsyncImage(url: URL(string: imageManager.queryURL)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: 170, maxHeight: 100)
                        .clipShape(.rect(cornerRadius: 5))
                        .shadow(radius: 10)
                    
                } placeholder: {
                    HStack{
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                }
                
                Spacer()
                
                NavigationLink(destination: LocationDetailView(location: nearestLocations[index])) {
                    Button {}
                    label: {
                        Text("Investigate")
                    }
                    .padding(.trailing, 30)
                    .foregroundStyle(Color.green)
                    .buttonStyle(.borderedProminent)
                }
                
            }
            
            HStack{
                Spacer()
                
                if nearestLocations[index] != nearestLocations.first{
                    Button {
                        moveLeft()
                    } label: {
                    Image(systemName: "arrow.left")
                }
                .buttonStyle(.borderedProminent)
                }
                else {
                    Button {}
                    label: {
                        Image(systemName: "arrow.left")
                    }
                    .buttonStyle(.bordered)
                }
                
                Spacer()
                Spacer()
                
                if nearestLocations[index] != nearestLocations.last{
                    Button {
                        moveRight()
                    } label: {
                    Image(systemName: "arrow.right")
                }
                .buttonStyle(.borderedProminent)
                }
                else {
                    Button {}
                    label: {
                        Image(systemName: "arrow.right")
                    }
                    .buttonStyle(.bordered)
                }
                
                Spacer()
            }
            .padding(.vertical, 30)
            
            Spacer()
        }
        .padding()
        .onChange(of: index) {
            Task {
                await imageManager.getImage(for: nearestLocations[index].name)
                print(imageManager.queryURL)
            }
        }
    }
    
    
    func moveRight() {
        index += 1
        
        updateCamera(to: index)
        
    }
    
    func moveLeft() {
        index -= 1
        updateCamera(to: index)
    }
    
    func updateCamera(to index: Int) {
        cameraPosition = .region(MKCoordinateRegion(center: nearestLocations[index].coordinates, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)))
    }
}



#Preview {
    LocationPreviewView(cameraPosition: .constant(.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.787_994, longitude: -122.407_437), span: .init(latitudeDelta: 0.1, longitudeDelta: 0.1)))), nearestLocations: [HauntedLocation.example, HauntedLocation.allLocations[1]])
}
