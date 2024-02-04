//
//  LocationDetail.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 1/9/24.
//

import SwiftUI
import StoreKit
import MapKit

struct LocationDetailView: View {

    @Environment(\.dismiss) var dismiss
    @State private var viewModel = ViewModel()
    @State private var imageManager = GoogleAPIManager()
    
    @State private var uiImage : UIImage?

    var location: HauntedLocation
        
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack(alignment: .leading, spacing: 20){
                    
                    imageSection
                    
                    header
                    
                    Divider()
                    
                    bodySection
                    
                    Divider()
                    
                    lookAroundSection
                }
                .padding()
                .onAppear {
                    viewModel.fetchLookAroundPreview(for: location.coordinates)
                    viewModel.loadSavedLoations()
                }
            }
            .toolbar {
                ToolbarItem{
                    Button {
                        toggleStar()
                    } label: {
                        Image(systemName: viewModel.isInFavorites(location: location) ? "star.fill" : "star")
                    }
                }
            }
            .task {
                await imageManager.fetchURL(for: location.name)
            }
        }
    }
    func toggleStar() {
        if !viewModel.isInFavorites(location: location) {
            viewModel.savedLocations.append(location)
        }
        else {
            if let index = viewModel.savedLocations.firstIndex(of: location) {
                viewModel.savedLocations.remove(at: index)
            }
        }
    }
}
#Preview {
    LocationDetailView(location: HauntedLocation.allLocations[4234])
}

extension LocationDetailView {
    
    private var header: some View {
        VStack(alignment: .leading, spacing: 8){
            Text(location.name)
                .font(.title.bold())
            Label("\(location.city), \(location.stateAbbrev)", systemImage: "map")
                .font(.subheadline)
        }
    }
    
    private var imageSection: some View {
        VStack{
            if let image = viewModel.proccessedImage {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipped()
                        .frame(maxHeight: 250)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 3))
            }
            
        }
        .task {
            await imageManager.fetchURL(for: location.name)
            await viewModel.loadAndProccessImage(url: imageManager.queryURL)
        }
        
    }
    
    private var bodySection: some View {
        VStack(alignment: .leading, spacing: 10){
            Label("Details", systemImage: "doc.text.magnifyingglass")
                .font(.title2)
            Text(location.description)
        }
    }
    
    private var lookAroundSection: some View {
        ZStack{
            if viewModel.lookAroundPlace == nil {
                Label("No Lookaround Available", systemImage: "eye.slash")
            }
            else {
                VStack(alignment: .leading){
                    Label("See for yourself", systemImage: "binoculars.fill")
                        .font(.title2)
                    LookAroundPreview(scene: $viewModel.lookAroundPlace)
                        .clipShape(.rect(cornerRadius: 10))
                }
                .frame(height: 200)
            }
        }
    }
}
