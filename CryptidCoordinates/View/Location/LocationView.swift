//
//  LocationDetail.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 1/9/24.
//

import MapKit
import Kingfisher
import SwiftUI

struct LocationView: View {
    var location: Location
    @Environment(\.colorScheme) var colorScheme
    @Environment(ViewModel.self) var viewModel
    @State private var imageUrl: URL?
    @State private var lookAroundPlace: MKLookAroundScene?
    @State private var isShowingLookAround = false
    @State private var comment = ""
    @State private var didLike = false
    @State private var didFavorite = false
    @State private var comments: [Comment] = []
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 30){
                KFImage(location.url)
                    .resizable()
                    .scaledToFill()
                    .overlay(alignment: .topLeading){
                        BackButton()
                            .padding(7)
                            .background(.ultraThickMaterial, in: Circle())
                            .padding(25)
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
                await fetchLookAround()
                do {
                    comments = try await viewModel.fetchComments(locationId: location.id)
                } catch {
                    print("Error fechComments(): \(error.localizedDescription)")
                }
            }
            .fullScreenCover(isPresented: $isShowingLookAround) {
                LookAroundPreview(initialScene: lookAroundPlace)
            }
        }
        .navigationBarBackButtonHidden()
        .ignoresSafeArea()
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
                withAnimation(.easeInOut){
                    viewModel.selectedLocation = location
                }
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
        }
        .imageScale(.large)
        .frame(maxWidth: .infinity, alignment: .center)
    }
        
    private func fetchLookAround() async {
        let request = MKLookAroundSceneRequest(coordinate: location.coordinates)
        lookAroundPlace = try? await request.scene
    }
}

#Preview {
    NavigationStack {
        LocationView(location: Location.example)
            .environment(ViewModel(user: .example))
    }
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
