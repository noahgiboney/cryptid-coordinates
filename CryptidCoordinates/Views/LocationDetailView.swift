//
//  LocationDetail.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 1/9/24.
//

import SwiftUI
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
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "arrow.uturn.backward")
                    }
                }
                ToolbarItem(placement: .topBarTrailing){
                    Button {
                        
                    } label: {
                        Text("Save")
                        Image(systemName: "star")
                    }
                }
            }
        }
    }
}
#Preview {
    LocationDetailView(location: HauntedLocation.allLocations[6534])
}

extension LocationDetailView {
    
    private var header: some View {
        VStack(alignment: .leading, spacing: 8){
            Text(location.name)
                .font(.title.bold())
            Label("\(location.city), \(location.stateAbbrev)", systemImage: "map")
        }
    }
    
    private var bodySection: some View {
        VStack(alignment: .leading, spacing: 10){
            Label("Details", systemImage: "doc.text.magnifyingglass")
                .font(.title)
            Text(location.description)
        }
    }
    
    private var lookAroundSection: some View {
        ZStack{
            if viewModel.lookAroundPlace == nil {
                Label("No Lookaround Available", systemImage: "eye.slash")
                    .font(.title2)
            }
            else {
                VStack(alignment: .leading){
                    Label("See for yourself", systemImage: "binoculars.fill")
                        .font(.title)
                    LookAroundPreview(scene: $viewModel.lookAroundPlace)
                        .clipShape(.rect(cornerRadius: 10))
                }
                .frame(height: 200)
            }
        }
    }
}
