//
//  PreviewImage.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 7/11/24.
//

import SwiftUI

enum ImageSize {
    case preview, detail
}

struct FilteredImage: View {
    var url: URL?
    var size: ImageSize
    @State private var imageHelper = ImageHelper()
    
    var body: some View {
        Group {
            switch size {
            case .preview:
                if let image = imageHelper.image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .frame(maxWidth: .infinity, maxHeight: 275)
                        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                }
            case .detail:
                if let image = imageHelper.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                }
            }
        }
        .onAppear {
            imageHelper.loadImage(url: url)
        }
    }
}

#Preview {
    FilteredImage(url: Location.example.url, size: .preview)
}
