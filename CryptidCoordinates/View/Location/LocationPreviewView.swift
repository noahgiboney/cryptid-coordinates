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
    @Environment(\.colorScheme) var colorScheme
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
                    .frame(height: 249)
                    .frame(width: 350)
            case .loaded:
                previewView
            case .error:
                previewView
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
                    .frame(maxHeight: 170)
            } else {
                Image(systemName: "camera")
                    .imageScale(.large)
                    .frame(height: 170)
                    .foregroundStyle(colorScheme == .light ? .black : .white)
            }
            
            VStack(spacing: 0) {
                Rectangle()
                    .fill(Color(uiColor: .systemBackground))
                    .frame(height: 2.5)
                
                HStack(alignment: .bottom) {
                    VStack(alignment: .leading) {
                        Text(location.name)
                            .fontWeight(.semibold)
                        Text(location.cityState)
                            .font(.footnote)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .overlay(alignment:.bottomTrailing) {
                        if let userCords = locationManager.lastKnownLocation {
                            Text("\(location.distanceAway(userCords)) Miles Away")
                                .font(.footnote)
                        }
                    }
                }
                .padding(15)
                .foregroundStyle(.white)
                .background(Color(uiColor: averageColor))
            }
        }
        .frame(width: 350)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay {
            RoundedRectangle(cornerRadius: 20).stroke(colorScheme == .light ? .black : .white, lineWidth: loadState == .error ? 1 : 0)
        }
        .shadow(color: .black.opacity(0.3), radius: loadState == .loaded ? 5 : 0, x: 0, y: loadState == .loaded ? 5 : 0)
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

