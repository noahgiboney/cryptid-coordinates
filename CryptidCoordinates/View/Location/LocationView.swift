//
//  LocationView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 1/9/24.
//

import MapKit
import Kingfisher
import SwiftUI

struct LocationView: View {
    @Bindable var location: Location
    @Environment(\.colorScheme) var colorScheme
    @Environment(GlobalModel.self) var global
    @Environment(LocationStore.self) var store
    @Environment(Saved.self) var saved
    @EnvironmentObject var locationManager: LocationManager
    @State private var lookAroundPlace: MKLookAroundScene?
    @State private var showVisitSheet = false
    @State private var showLookAround = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 25){
                VStack {
                    KFImage(location.url)
                        .loadDiskFileSynchronously()
                        .cacheMemoryOnly()
                        .fade(duration: 0.25)
                        .resizable()
                        .frame(maxWidth: .infinity, maxHeight: 400)
                    
                    locationHeader
                }
                
                actionButtons
                
                VStack(spacing: 15){
                    Text(location.detail)
                        .padding(.horizontal)
                    Divider()
                }
                
                CommentSection(locationId: location.id)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await fetchLookAround()
        }
        .fullScreenCover(isPresented: $showLookAround) {
            LookAroundPreview(initialScene: lookAroundPlace)
                .ignoresSafeArea()
        }
        .sheet(isPresented: $showVisitSheet) {
            VisitView(location: location)
                .presentationDetents([.medium])
                .presentationCornerRadius(20)
        }
    }
    
    var locationHeader: some View {
            VStack(alignment: .leading ,spacing: 3){
                Text(location.name)
                    .font(.title.bold())
                
                Text(location.cityState)
                    .foregroundStyle(.secondary)
            }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var actionButtons: some View {
        HStack(spacing: 20){
            Button {
                global.selectedLocation = location
            } label: {
                Image(systemName: "map")
            }
            
            Button {
                openInMaps(location)
            } label: {
                Image(systemName: "location")
            }
            
            if lookAroundPlace != nil {
                Button {
                    showLookAround.toggle()
                } label: {
                    Image(systemName: "eye")
                }
            }
            
            Spacer()
            
            Button {
                saved.update(location)
            } label: {
                Image(systemName: saved.contains(location) ? "bookmark.fill" : "bookmark")
            }
            
            Button("Visit") {
                showVisitSheet.toggle()
            }
            .buttonStyle(.bordered)
        }
        .imageScale(.large)
        .padding(.horizontal, 20)
    }
        
    func fetchLookAround() async {
        let request = MKLookAroundSceneRequest(coordinate: location.coordinates)
        lookAroundPlace = try? await request.scene
    }
    
    func openInMaps(_ location: Location) {
        let item = MKMapItem(placemark: MKPlacemark(coordinate: location.coordinates))
        item.openInMaps()
    }
}

#Preview {
    NavigationStack {
        LocationView(location: Location.example)
            .environment(GlobalModel(user: .example))
            .environment(Saved())
            .environmentObject(LocationManager())
    }
}
