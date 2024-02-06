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
    
    // location to preview
    var location: HauntedLocation
    
    var body: some View {
            ScrollView{
                VStack(alignment: .leading){
                    imageSection
                    header
                    Divider()
                    details
                    lookAroundSection
                }
                .onAppear {
                    viewModel.fetchLookAroundPreview(for: location.coordinates)
                    viewModel.loadSavedLoations()
                }
            }
    }
}
#Preview {
    LocationDetailView(location: HauntedLocation.allLocations[4234])
}

extension LocationDetailView {
    
    private var imageSection: some View {
        ZStack(alignment: .topLeading){
            if let image = viewModel.proccessedImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipped()
                    .frame(maxHeight: 200)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 3))
            }
            HStack{
                Spacer()
                Button {
                    viewModel.toggleStar(location: location)
                }label: {
                    Image(systemName: viewModel.isInFavorites(location: location) ? "star.fill" : "star")
                        .darkButtonStyle(foreground: .yellow)
                }
                .padding(10)
            }
        }
        .task {
            await imageManager.fetchURL(for: location.name)
            await viewModel.loadAndProccessImage(url: imageManager.queryURL)
        }
        
    }
    
    private var header: some View {
        VStack(alignment: .leading, spacing: 8){
            Text(location.name)
                .font(.title.bold())
            Text("\(location.city), \(location.stateAbbrev)")
                .font(.subheadline)
        }
        .padding()
    }
    
    private var details: some View {
        VStack(alignment: .leading, spacing: 5){
            Image(systemName: "doc.text.magnifyingglass")
            Text(location.description)
            
            Button{
                viewModel.openInMaps(location)
            } label: {
                Label("Directions", systemImage: "map")
                    .darkButtonStyle(foreground: .blue)
            }
            .padding(.top)
        }
        .padding(.top, 2)
        .padding([.horizontal, .bottom])
    }
    
    private var lookAroundSection: some View {
        ZStack{
            if viewModel.lookAroundPlace == nil {
                Label("No Lookaround Available", systemImage: "eye.slash")
            }
            else {
                VStack(alignment: .leading){
                    LookAroundPreview(scene: $viewModel.lookAroundPlace)
                        .clipShape(.rect(cornerRadius: 10))
                }
                .frame(height: 200)
            }
        }
        .padding()
    }
}
