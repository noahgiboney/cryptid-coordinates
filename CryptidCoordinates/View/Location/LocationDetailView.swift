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
    let location: Location
    @Environment(\.colorScheme) var colorScheme
    @Environment(ViewModel.self) var viewModel
    @Environment(\.dismiss) var dismiss
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
                    .clipShape(RoundedRectangle(cornerRadius: 5))
//                    .overlay(alignment: .topLeading) {
//                        Button {
//                            dismiss()
//                        } label: {
//                            Image(systemName: "chevron.left")
//                                .imageScale(.large)
//                                .padding(7)
//                                .background(.ultraThickMaterial)
//                                .clipShape(Circle())
//                        }
//                        .padding(.leading, 30)
//                        .padding(.top, 30)
//                    }

                
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
                comments = try! await viewModel.fetchComments(locationId: location.id)
            }
            .fullScreenCover(isPresented: $isShowingLookAround) {
                LookAroundPreview(initialScene: lookAroundPlace)
            }
        }
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
        
    private func fetchLookAround() async {
        let request = MKLookAroundSceneRequest(coordinate: location.coordinates)
        lookAroundPlace = try? await request.scene
    }
}

#Preview {
    LocationDetailView(location: Location.example)
        .environment(ViewModel(user: .example))
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
