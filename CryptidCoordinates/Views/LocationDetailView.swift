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
                Button {
                    dismiss()
                }label: {
                    Image(systemName: "arrow.down.right.and.arrow.up.left")
                        .darkButtonStyle(foreground: .red)
                }
                .padding()
                
                Spacer()
                Button {
                    withAnimation(.smooth){
                        toggleStar()
                    }
                }label: {
                    Image(systemName: viewModel.isInFavorites(location: location) ? "star.fill" : "star")
                        .darkButtonStyle(foreground: .blue)
                }
                .padding()
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
            Label("\(location.city), \(location.stateAbbrev)", systemImage: "map")
                .font(.subheadline)
        }
        .padding()
    }
    
    private var details: some View {
        VStack(alignment: .leading, spacing: 5){

            Image(systemName: "doc.text.magnifyingglass")
            
            Text(location.description)
            
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
                    Label("See for yourself", systemImage: "binoculars.fill")
                        .font(.title2)
                    LookAroundPreview(scene: $viewModel.lookAroundPlace)
                        .clipShape(.rect(cornerRadius: 10))
                }
                .frame(height: 200)
            }
        }
        .padding()
    }
}
