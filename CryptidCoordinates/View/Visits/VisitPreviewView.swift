//
//  VisitPreviewView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 7/28/24.
//

import Kingfisher
import Firebase
import SwiftData
import SwiftUI

struct VisitPreviewView: View {
    var location: Location
    var visitDate: Timestamp
    @State private var loadState: LoadState = .loading
    @State private var image: UIImage?
    
    var averageColor: UIColor {
        image?.findAverageColor(algorithm: .simple) ?? .gray
    }
    
    var body: some View {
        Group {
            switch loadState {
            case .loading:
                ProgressView()
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
        VStack(alignment: .center) {
            if let uiImage = image {
                NavigationLink {
                    LocationView(location: location)
                } label: {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 75, height: 75)
                        .clipShape(Circle())
                        .overlay(
                            Circle().stroke(Color(uiColor: averageColor), lineWidth: 3)
                        )
                        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 0)
                }
            }
            
            VStack(alignment: .center) {
                Text(location.name)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                
                Text("Visited \(visitDate.dateValue().formatted(date: .abbreviated, time: .shortened))")
                    .font(.caption2)
                    .foregroundStyle(.gray)
            }
        }
        .padding(.vertical)
        .containerRelativeFrame(.horizontal, count: 2, spacing: 10)
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
    
    return VisitPreviewView(location: .example, visitDate: Timestamp()).modelContainer(container)
}
