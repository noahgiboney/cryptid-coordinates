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

    var location: HauntedLocation
        
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack(alignment: .leading, spacing: 20){
                    
                    header
                    
                    imageSection
                    
                    Divider()
                    
                    bodySection
                    
                    Divider()
                    
                    lookAroundSection
                }
                .padding()
                .onAppear {
                    viewModel.fetchLookAroundPreview(for: location.coordinates)
                }
            }
            .toolbar {
                
                ToolbarItem(placement: .topBarLeading){
                    Button("Dismiss"){
                        dismiss()
                    }
                }
                
                ToolbarItem{
                    Button {
                        toggleStar()
                    } label: {
                        Image(systemName: viewModel.isInFavorites(location: location) ? "star.fill" : "star")
                    }
                }
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
        .environment(UserFavorites())
}

extension LocationDetailView {
    
    private var header: some View {
        VStack(alignment: .leading, spacing: 8){
            Text(location.name)
                .font(.title.bold())
            Label("\(location.city), \(location.stateAbbrev)", systemImage: "map")
                .font(.subheadline.italic())
        }
    }
    
    private var imageSection: some View {
        VStack{
            AsyncImage(url: URL(string: imageManager.queryURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 250, height: 140)
                    .clipped()
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            } placeholder: {
                HStack {
                }
            }
        }
        .task {
            await imageManager.getImage(for: location.name)
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
