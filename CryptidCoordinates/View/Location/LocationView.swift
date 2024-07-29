//
//  LocationView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 1/9/24.
//

import MapKit
import Kingfisher
import SwiftData
import SwiftUI

struct LocationView: View {
    @Bindable var location: Location
    @Environment(\.colorScheme) var colorScheme
    @Environment(GlobalModel.self) var global
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
                saved.update(location)
            } label: {
                Image(systemName: saved.contains(location) ? "bookmark.fill" : "bookmark")
            }
            .symbolEffect(.bounce, value: saved.contains(location))
            
            Menu {
                Button("Get Directions", systemImage: "map") {
                    openInMaps(location)
                }
                
                Button("View On Map", systemImage: "location")  {
                    
                }
                
            } label: {
                Image(systemName: "list.bullet")
            }

            if lookAroundPlace != nil {
                Button {
                    showLookAround.toggle()
                } label: {
                    Image(systemName: "eye")
                }
            }
            
            Spacer()
            
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
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Location.self, configurations: config)
    
    return NavigationStack {
        LocationView(location: Location.example)
            .modelContainer(container)
            .environment(GlobalModel(user: .example))
            .environment(Saved())
            .environmentObject(LocationManager())
    }
}
