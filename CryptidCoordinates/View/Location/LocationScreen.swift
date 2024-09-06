//
//  LocationView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 1/9/24.
//

import MapKit
import Kingfisher
import StoreKit
import SwiftData
import SwiftUI
import TipKit

struct LocationScreen: View {
    
    @Bindable var location: Location
    @AppStorage("locationsViewed") var locationsViewed = 0
    @AppStorage("lastVersionPromptedForReview") var lastVersionPromptedForReview = ""
    @Environment(\.requestReview) var requestReview
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    @Environment(Global.self) var global
    @Environment(Saved.self) var saved
    @EnvironmentObject var locationManager: LocationManager
    @State private var lookAroundPlace: MKLookAroundScene?
    @State private var showVisitSheet = false
    @State private var showLookAround = false
    
    private func fetchLookAround() async {
        let request = MKLookAroundSceneRequest(coordinate: location.coordinates)
        lookAroundPlace = try? await request.scene
    }
    
    private func openInMaps(_ location: Location) {
        let item = MKMapItem(placemark: MKPlacemark(coordinate: location.coordinates))
        item.openInMaps()
    }
    
    private func viewOnMap() {
        global.selectedLocation = location
        if global.tabSelection == 1 {
            dismiss()
        }
    }
    
    private func presentReview() {
        Task {
            try await Task.sleep(for: .seconds(2.0))
            requestReview()
            lastVersionPromptedForReview = global.currentAppVersion
        }
    }
    
    var body: some View {
        ScrollView {
            ScrollViewReader { proxy in
                VStack(alignment: .leading, spacing: 25){
                    VStack {
                        KFImage(location.url)
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
                    
                    CommentSectionView(locationId: location.id, scrollProxy: proxy)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .fullScreenCover(isPresented: $showLookAround) {
            LookAroundPreview(initialScene: lookAroundPlace)
                .ignoresSafeArea()
        }
        .sheet(isPresented: $showVisitSheet) {
            VisitView(location: location)
                .presentationDetents([.fraction(0.45)])
                .presentationCornerRadius(15)
        }
        .onAppear{
            if locationsViewed >= 10 && lastVersionPromptedForReview != global.currentAppVersion {
                presentReview()
                lastVersionPromptedForReview = global.currentAppVersion
            } else if lastVersionPromptedForReview != global.currentAppVersion {
                locationsViewed += 1
            }
        }
        .task {
            await fetchLookAround()
            await VisitTip.viewLocationEvent.donate()
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
                    viewOnMap()
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
            
            Button {
                showVisitSheet.toggle()
            } label: {
                HStack(spacing: 10) {
                    Image(systemName: "waveform.badge.magnifyingglass")
                    Text("Visit")
                }
                .padding(.horizontal, 5)
            }
            .padding(5)
            .background(.accent)
            .foregroundColor(.white)
            .cornerRadius(10)
            .popoverTip(VisitTip.tip)
        }
        .imageScale(.large)
        .padding(.horizontal, 20)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Location.self, configurations: config)
    
    return NavigationStack {
        LocationScreen(location: Location.example)
            .modelContainer(container)
            .environment(Global(user: .example, defaultCords: Location.example.coordinates))
            .environment(Saved())
            .environmentObject(LocationManager())
    }
}
