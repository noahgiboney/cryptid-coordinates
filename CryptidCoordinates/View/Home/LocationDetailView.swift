//
//  LocationDetail.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 1/9/24.
//

import MapKit
import Kingfisher
import SwiftUI

struct LocationDetailView: View {
    @Environment(\.dismiss) var dismiss
    @State private var viewModel = ViewModel()
    @State private var imageUrl: URL?
    @State private var lookAroundPlace: MKLookAroundScene?
    @State private var isShowingLookAround = false
    @State private var didLoadImage = false
    @State private var comment = ""
    @State private var didLike = false
    @State private var didFavorite = false
    
    let location: OldLocation
    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading, spacing: 30){
                
                if didLoadImage {
                    if let imageUrl = imageUrl {
                        KFImage(imageUrl)
                            .resizable()
                            .scaledToFill()
                    } else {
                        Label("No Image Available", systemImage: "camera")
                            .foregroundStyle(.gray)
                            .font(.footnote)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                } else {
                    ProgressView()
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 100)
                }
                
                locationHeader
                
                Divider().padding(.horizontal, 50)
                
                Text(location.description)
                    .padding(.horizontal)
                
                VStack(spacing: 15){
                    Divider().padding(.horizontal, 50)
                    
                    actionButton
                    
                    Divider()
                }
                
                
                CommentSection(location: location)
            }
            .task {
                await fetchImage()
                await fetchLookAround()
            }
            .fullScreenCover(isPresented: $isShowingLookAround) {
                LookAroundPreview(initialScene: lookAroundPlace)
            }
        }
        .ignoresSafeArea(edges: .top)
    }
    
    var locationHeader: some View {
        VStack(spacing: 3){
            Text(location.name)
                .font(.title.bold())
            
            Text(location.cityState)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
    
    var actionButton: some View {
        HStack(spacing: 30){
            Button{
                didLike.toggle()
            } label: {
                Image(systemName: didLike ? "heart.fill" : "heart")
                    .symbolEffect(.bounce, value: didLike)
            }
            
            Button {
                didFavorite.toggle()
            } label: {
                Image(systemName: didFavorite ? "bookmark.fill" : "bookmark")
                    .symbolEffect(.bounce, value: didFavorite)
            }
            
            Button {
                
            } label: {
                Image(systemName: "map")
            }
            
            Button {
                
            } label: {
                Image(systemName: "eye")
            }
            
            Button {
                
            } label: {
                Image(systemName: "square.and.arrow.up")
            }
        }
        .imageScale(.large)
        .frame(maxWidth: .infinity, alignment: .center)
    }
    
    private func fetchImage() async {
        didLoadImage = false
        do {
            let url = try await GoolgeImageService.shared.fetchImageUrl(for: location.name + location.cityState)
            
            if let url = url {
                
            }
        } catch {
            print("DEBUG: error fetching image with error: \(error.localizedDescription)")
        }
        didLoadImage = true
    }
    
    private func fetchLookAround() async {
        let request = MKLookAroundSceneRequest(coordinate: location.coordinates)
        lookAroundPlace = try? await request.scene
    }
}

#Preview {
    LocationDetailView(location: OldLocation.allLocations[4234])
}

extension LocationDetailView{
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
