//
//  LocationPreviewView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 7/27/24.
//

import Kingfisher
import SwiftData
import SwiftUI

struct HorizontalLocationPreview: View {
    
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
                    loadState = .error
                }
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            locationImageView
            
            locationInfoView
        }
        .frame(width: 350)
        .onAppear {
            downloadImage()
        }
        .shadow(color: .black.opacity(0.6), radius: 10, x: 0, y: 5)
    }
    
    private var locationImageView: some View {
        ZStack {
            if loadState == .loading {
                ProgressView()
                    .frame(height: 170)
            } else {
                if let uiImage = image {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 350)
                        .frame(maxHeight: 170)
                        .clipShape(
                            .rect(
                                topLeadingRadius: 15,
                                bottomLeadingRadius: 0,
                                bottomTrailingRadius: 0,
                                topTrailingRadius: 15
                            )
                        )
                } else {
                    VStack {
                        Image(systemName: "eye.slash")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 60)
                            .foregroundStyle(colorScheme == .light ? .black : .white)
                            .frame(height: 170)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
    }
    
    private var locationInfoView: some View {
        VStack(spacing: 0) {            
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
            .background(LinearGradient(colors: gradientColors, startPoint: .leading, endPoint: .trailing))
            .clipShape(
                .rect(
                    topLeadingRadius: 0,
                    bottomLeadingRadius: 15,
                    bottomTrailingRadius: 15,
                    topTrailingRadius: 0
                )
            )
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Location.self, configurations: config)
    
    return HorizontalLocationPreview(location: .example)
        .modelContainer(container)
        .environmentObject(LocationManager())
}

