//
//  MapMarkerView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 7/7/24.
//

import Kingfisher
import SwiftUI

struct LocationMarkerView: View {
    var url: URL?
    @State private var loadState: LoadState = .loading
    @State private var image: UIImage?
    
    var outlineColor: Color {
        switch loadState {
        case .loading:
            return .white
        case .loaded:
            return .white
        case .error:
            return .gray.opacity(0.5)
        }
    }
    
    var body: some View {
        ZStack {
            Circle().fill(.white)
                .frame(width: 50, height: 50)
            
            switch loadState {
            case .loading:
                ProgressView()
            case .loaded:
                Image(uiImage: image!)
                    .resizable()
                    .clipShape(Circle())
                    .shadow(radius: 10)
                    .frame(maxWidth: 50, maxHeight: 50)
            case .error:
                Image(systemName: "camera")
                    .foregroundStyle(.black)
            }
        }
        .overlay(
            Circle().stroke(outlineColor, lineWidth: 2.5)
        )
        .onAppear { downloadImage() }
    }
    
    func downloadImage() {
        guard loadState == .loading else { return }
        
        guard let url = url else { return }
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
    LocationMarkerView()
}
