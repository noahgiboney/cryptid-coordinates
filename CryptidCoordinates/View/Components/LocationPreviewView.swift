//
//  LocationPreviewView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 7/27/24.
//

import Kingfisher
import SwiftData
import SwiftUI

struct LocationPreviewView: View {
    var location: Location
    @EnvironmentObject var locationManager: LocationManager
    @State private var image: UIImage?
    @State private var loadState: LoadState = .loading
    
    var averageColor: UIColor {
        image?.findAverageColor(algorithm: .simple) ?? .gray
    }
    
    var body: some View {
        Group {
            switch loadState {
            case .loading:
                ProgressView()
                    .frame(height: 234)
                    .containerRelativeFrame([.horizontal])
            case .loaded:
                previewView
            case .error:
                Image(systemName: "camera")
            }
        }
        .onAppear {
            downloadImage()
        }
    }
    
    var previewView: some View {
        VStack {
            if let uiImage = image {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(maxHeight: 160)
            }
            
            VStack(spacing: 0) {
                Rectangle()
                    .fill(Color(uiColor: .systemBackground))
                    .frame(height: 3)
                
                HStack(alignment: .bottom) {
                    VStack(alignment: .leading) {
                        Text(location.name)
                            .fontWeight(.semibold)
                        Text(location.cityState)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .overlay(alignment:.bottomTrailing) {
                        if let userCords = locationManager.lastKnownLocation {
                            Text("\(location.distanceAway(userCords)) Miles Away")
                                .font(.footnote)
                        }
                    }
                }
                .padding(10)
                .padding(.horizontal, 5)
                .foregroundStyle(.white)
                .background(Color(uiColor: averageColor))
            }
        }
        .containerRelativeFrame([.horizontal])
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 0)
    }
    
    func downloadImage() {
        guard loadState == .loading else { return }
        
        guard let url = URL(string: location.imageUrl) else { return }
        let resource = ImageResource(downloadURL: url)

        KingfisherManager.shared.retrieveImage(with: resource, options: [.cacheOriginalImage], progressBlock: nil) { result in
            switch result {
            case .success(let value):
                DispatchQueue.main.async {
                    image = value.image
                    loadState = .loaded
                }
            case .failure(_):
                loadState = .error
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Location.self, configurations: config)
    
    return LocationPreviewView(location: .example)
        .modelContainer(container)
        .environmentObject(LocationManager())
}

