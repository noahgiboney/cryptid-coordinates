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
    let location: Location
    let visitDate: Timestamp
    @Environment(\.colorScheme) var colorScheme
    @State private var loadState: LoadState = .loading
    @State private var image: UIImage?
    
    private var averageColor: UIColor {
        image?.findAverageColor(algorithm: .simple) ?? .gray
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
        VStack {
            NavigationLink {
                LocationView(location: location)
            } label: {
                locationNavLinkLabel
            }
            
            visitInfoView
        }
        .containerRelativeFrame(.horizontal, count: 2, spacing: 10)
        .padding(.vertical)
        .onAppear {
            downloadImage()
        }
    }
    
    private var visitInfoView: some View {
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
    
    @ViewBuilder
    private var locationNavLinkLabel: some View {
        if loadState == .loaded {
            if let uiImage = image {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 75, height: 75)
                    .clipShape(Circle())
                    .overlay(
                        Circle().stroke(Color(uiColor: averageColor), lineWidth: 3)
                    )
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 0)
            } else {
                ZStack {
                    Circle()
                        .fill(Color(uiColor: .systemBackground))
                        .frame(width: 75, height: 75)
                    
                    Image(systemName: "eye.slash")
                        .foregroundStyle(colorScheme == .dark ? .white : .black)
                        .imageScale(.large)
                }
                .overlay(
                    Circle().stroke(Color(uiColor: averageColor), lineWidth: 3)
                )
            }
        } else {
            ZStack {
                Circle()
                    .fill(Color(uiColor: .systemBackground))
                    .frame(width: 75, height: 75)
                
                ProgressView()
            }
            .overlay(
                Circle().stroke(Color(uiColor: averageColor), lineWidth: 3)
            )
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Location.self, configurations: config)
    
    return VisitPreviewView(location: .example, visitDate: Timestamp()).modelContainer(container)
}
