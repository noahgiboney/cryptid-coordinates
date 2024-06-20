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
    @State private var likeTapped = false
    let location: OldLocation
    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading, spacing: 30){
                
                VStack(alignment: .leading, spacing: 15) {
                    locationHeader
                    
                    Text(location.description)
                        .padding(.horizontal)
                }
                
                if didLoadImage {
                    if let imageUrl = imageUrl {
                        KFImage(imageUrl)
                            .resizable()
                            .scaledToFill()
                            .frame(maxHeight: 200)
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
                
                actionButtons
                
                commentSection()
                
                
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
    
    private func fetchImage() async {
        didLoadImage = false
        do {
            let url = try await GoolgeImageService.shared.fetchImageUrl(for: location.name + location.cityState)
            
            if let url = url {
                imageUrl = URL(string: url)
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

extension LocationDetailView {
    
    private var actionButtons: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Button {
                    
                } label: {
                    Label("Map", systemImage: "map")
                }
                .buttonStyle(.bordered)
                
                if lookAroundPlace == lookAroundPlace{
                    Button {
                        
                    } label: {
                        Label("Look", systemImage: "eye")
                    }
                    .buttonStyle(.bordered)
                }
            }
            .padding(.leading)
            
            HStack(spacing: 30) {
                HStack {
                    Button {
                        likeTapped.toggle()
                    } label: {
                        Image(systemName: likeTapped ? "hand.thumbsup.fill" : "hand.thumbsup")
                            .symbolEffect(.bounce, value: likeTapped)
                    }
                    
                    Text("\(55)")
                }
                .foregroundStyle(.green)
                
                HStack {
                    Button(role: .destructive) {
                        
                    } label: {
                        Image(systemName: "hand.thumbsdown")
                    }
                    
                    Text("\(100)")
                }
                .foregroundStyle(.red)
                
                Button {
                    
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
                
                Spacer()
                
                Button {
                    
                } label: {
                    Image(systemName: "star")
                        .foregroundStyle(.yellow)
                }
            }
            .font(.subheadline)
            .padding(.horizontal)
            .frame(maxWidth: .infinity, alignment: .center)
            .imageScale(.large)
        }
    }
    
    @ViewBuilder
    private func commentSection() -> some View {
        HStack {
            TextField("Share Your Experince", text: $comment)
                .overlay(alignment: .bottom) {
                    Rectangle()
                        .foregroundStyle(.gray)
                        .frame(height: 0.5)
                        .offset(y: 6)
                }
            
            Button {
                
            } label: {
                Image(systemName: "arrow.up.circle.fill")
                    .imageScale(.large)
                    .foregroundStyle(.black)
            }
        }
        .padding(.horizontal)
        
        LazyVStack(alignment: .leading, spacing: 25) {
            ForEach(0..<10) { _ in
                CommentView(comment: Comment.example)
            }
        }
        .padding(.leading)
    }
    
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
                    Image(systemName: "arrow.down.left.arrow.up.right")
                        .darkLabelStyle(foreground: .red)
                        .scaleEffect(CGSize(width: 0.75, height: 0.75))
                }
                .padding(5)
            }
        }
    }
    
    private var locationHeader: some View {
        
        VStack(alignment: .leading, spacing: 3){
            
            Text(location.name)
                .font(.title.bold())
            
            Text("\(location.city), \(location.stateAbbrev)")
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal)
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
