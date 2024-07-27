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
    @State private var averageColor: UIColor?
    
    var body: some View {
        VStack(spacing: 10) {
            KFImage(location.url)
                .placeholder { _ in
                    VStack {
                        Image(systemName: "camera")
                            .imageScale(.large)
                            .scaleEffect(2)
                            .foregroundStyle(.black)
                    }
                    .frame(height: 160)
                }
                .loadDiskFileSynchronously()
                .cacheMemoryOnly()
                .fade(duration: 0.25)
                .resizable()
                .frame(maxWidth: .infinity, maxHeight: 160)
                .containerRelativeFrame(.horizontal, count: 1, span: 1, spacing: 10)
            
            HStack {
                VStack(alignment: .leading) {
                    Text(location.name)
                        .font(.headline)
                        .foregroundStyle(.white)
                    
                    Text(location.cityState)
                        .font(.footnote)
                        .foregroundStyle(.white)
                }
                
                Spacer()
                
                if let userCords = locationManager.lastKnownLocation {
                    VStack {
                        Text("\(location.distanceAway(userCords))")
                            .font(.footnote)
                        Text("Miles Away")
                            .font(.caption)
                    }
                    .foregroundStyle(.white)
                }
            }
            .padding(.horizontal)
        }
        .padding(.bottom)
        .background(Color(uiColor: averageColor ?? .white))
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .onAppear {
            loadImage()
        }
    }
    
    func loadImage() {
        guard let url = location.url else { return }
        
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try Data(contentsOf: url)
                DispatchQueue.main.async {
                    if let uiImage = UIImage(data: data) {
                        averageColor = uiImage.averageColor
                    }
                }
            } catch {
                
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

