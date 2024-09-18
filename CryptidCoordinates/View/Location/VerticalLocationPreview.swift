//
//  VerticalLocationPreview.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 9/7/24.
//

import Kingfisher
import SwiftData
import SwiftUI

struct VerticalLocationPreview: View {
    
    let location: Location
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var locationManager: LocationManager
    @State private var image: UIImage?
    @State private var loadState: LoadState = .loading
    
    private var gradientColors: [Color] {
        let averageColor = image?.findAverageColor(algorithm: .simple) ?? .gray
        
        return Color(uiColor: averageColor).findSimilarColors()
    }
    
    private func downloadImage() {
        guard loadState == .loading else { return }
        guard let url = URL(string: location.imageUrl) else { return }
        
        let resource = KF.ImageResource(downloadURL: url)
        
        KingfisherManager.shared.retrieveImage(with: resource) { result in
            switch result {
            case .success(let value):
                DispatchQueue.main.async {
                    image = value.image
                    loadState = .loaded
                }
            case .failure(_):
                DispatchQueue.main.async {
                    loadState = .loaded
                }
            }
        }
    }
    
    var body: some View {
        VStack(alignment:.leading, spacing: 0) {
            imageView
                .frame(maxWidth: .infinity)
            infoView
        }
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .padding(.horizontal, 12)
        .onAppear {
            downloadImage()
        }
    }
    
    @ViewBuilder
    private var imageView: some View {
        if loadState == .loaded {
            if let uiImage = image {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: 400)
            } else {
                Image(systemName: "eye.slash")
                    .foregroundStyle(colorScheme == .dark ? .white : .black)
                    .imageScale(.large)
                    .frame(height: 100)
            }
        } else {
            ProgressView()
                .frame(height: 100)
        }
    }
    
    private var infoView: some View {
        VStack(alignment: .leading) {
            Text(location.name)
                .font(.headline)
            Text(location.cityState)
                .font(.footnote)
            if let userCords = locationManager.lastKnownLocation {
                Text("\(location.distanceAway(userCords)) Miles Away")
                    .font(.footnote)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .foregroundStyle(.white)
        .padding()
        .background(LinearGradient(colors: gradientColors, startPoint: .bottomLeading, endPoint: .topTrailing))
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Location.self, configurations: config)
    
    return VerticalLocationPreview(location: .example)
        .modelContainer(container)
        .environmentObject(LocationManager())
}
