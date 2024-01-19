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
                    VStack(alignment: .leading, spacing: 8){
                        Text(location.name)
                            .font(.title.bold())
                        Text("\(location.city), \(location.country)")
                            .font(.subheadline.italic())
                            .padding(.bottom)
                        Text(location.coordinateString)
                            .font(.subheadline)
                    }
                    
                    Divider()
                    
                    Label(
                        title: { Text("Detailed Accout") },
                        icon: { Image(systemName: "doc.text.magnifyingglass") }
                    )
                    .font(.title2.weight(.medium))
                    
                    Text(location.description)
                    
                    AsyncImage(url: URL(string: imageManager.queryURL)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .border(Color.black)
                    } placeholder: {}
                    
                    Divider()
                    
                    ZStack{
                        if viewModel.lookAroundPlace == nil {
                            ContentUnavailableView("No Preview Available", systemImage: "eye.slash")
                        }
                        else {
                            VStack(alignment: .leading){
                                Label("Take a look around the area.", systemImage: "eye")
                                    .font(.title3.weight(.medium))
                                LookAroundPreview(scene: $viewModel.lookAroundPlace)
                                    .clipShape(Rectangle())
                            }
                        }
                    }
                    .frame(height: 200)
                    .clipShape(Rectangle())
                    .shadow(radius: 20)
                    
                    Divider()
                }
                .padding()
                .onAppear {
                    viewModel.fetchLookAroundPreview(for: location.coordinates)
                }
            }
            .task{
                await imageManager.getImage(for: "\(location.name)")
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading){
                    Button("Close") {
                        dismiss()
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
    LocationDetailView(location: HauntedLocation.example)
}
