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
    @Environment(\.colorScheme) var colorScheme
    @Environment(ViewModel.self) var viewModel
    @Environment(\.dismiss) var dismiss
    @State private var imageUrl: URL?
    @State private var lookAroundPlace: MKLookAroundScene?
    @State private var isShowingLookAround = false
    @State private var didLoadImage = false
    @State private var comment = ""
    @State private var didLike = false
    @State private var didFavorite = false
    
    let location: Location
    
    var body: some View {
        ScrollView{
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .imageScale(.large)
                        .padding(7)
                        .background(.ultraThickMaterial)
                        .clipShape(Circle())
                }
                Spacer()
            }
            .padding(.leading)
            
            VStack(alignment: .leading, spacing: 30){
                
                if didLoadImage {
                    if let imageUrl = imageUrl {
                        KFImage(imageUrl)
                            .resizable()
                            .scaledToFill()
                    }
                }
                
                locationHeader
                
                Text(location.description)
                    .padding(.horizontal)
                
                VStack(spacing: 15){
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
        HStack(spacing: 25){
            Button{
                didLike.toggle()
            } label: {
                Image(systemName: didLike ? "heart.fill" : "heart")
                    .symbolEffect(.bounce, value: didLike)
                    .padding(7)
                    .background(.ultraThickMaterial)
                    .clipShape(Circle())
            }
            
            Button {
                didFavorite.toggle()
            } label: {
                Image(systemName: didFavorite ? "bookmark.fill" : "bookmark")
                    .symbolEffect(.bounce, value: didFavorite)
                    .padding(7)
                    .background(.ultraThickMaterial)
                    .clipShape(Circle())
            }
            
            Button {
                viewModel.tabSelection = 1
            } label: {
                Image(systemName: "map")
                    .padding(7)
                    .background(.ultraThickMaterial)
                    .clipShape(Circle())
            }
            
            Button {
                
            } label: {
                Image(systemName: "eye")
                    .padding(7)
                    .background(.ultraThickMaterial)
                    .clipShape(Circle())
            }
            
            Button {
                
            } label: {
                Image(systemName: "square.and.arrow.up")
                    .padding(7)
                    .background(.ultraThickMaterial)
                    .clipShape(Circle())
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
    LocationDetailView(location: Location.example)
        .environment(ViewModel())
        .preferredColorScheme(.dark)
}

//extension LocationDetailView{
//    private var lookAroundSection: some View {
//        
//        ZStack{
//            
//            if viewModel.lookAroundPlace == nil {
//                
//                Label("No Lookaround Available", systemImage: "eye.slash")
//            }
//            else {
//                
//                VStack(alignment: .leading){
//                    LookAroundPreview(scene: $viewModel.lookAroundPlace)
//                        .clipShape(.rect(cornerRadius: 10))
//                }
//                .frame(height: 200)
//            }
//        }
//        .padding()
//    }
//}
