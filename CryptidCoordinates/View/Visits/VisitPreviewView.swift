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
                HStack(spacing: 20) {
                    if let uiImage = image {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 75, height: 75)
                            .clipShape(Circle())
                            .overlay(
                                Circle().stroke(Color.white, lineWidth: 0.75)
                            )
                    }
                    
                    VStack(alignment: .leading) {
                        Text(location.name)
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .fontWeight(.semibold)
                        
                        Text("Visited \(visitDate.dateValue().formatted(date: .abbreviated, time: .shortened))")
                            .font(.footnote)
                    }
                    
                    Spacer()
                }
                .foregroundStyle(.white)
                .padding()
                .listRowInsets(EdgeInsets())
                .frame(maxWidth: .infinity)
                .background(Color(uiColor: averageColor))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding(.horizontal)
                .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 0)
                .padding(.vertical, 5)
            case .error:
                Image(systemName: "camera")
            }
        }
        .onAppear {
            downloadImage()
        }
        
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
