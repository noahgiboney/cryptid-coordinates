//
//  MapAnnotationView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 9/4/24.
//

import Kingfisher
import SwiftData
import SwiftUI

struct MapAnnotationView: View {
    
    let url: URL?
    @State private var didFail = false
    
    var body: some View {
        KFImage(url)
            .placeholder { _ in
                ZStack {
                    Circle().fill(.white)
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: "eye.slash")
                        .foregroundStyle(.black)
                }
            }
            .onSuccess { _ in
                didFail = false
            }
            .onFailure { _ in
                didFail  = true
            }
            .loadDiskFileSynchronously()
            .cacheMemoryOnly()
            .fade(duration: 0.25)
            .resizable()
            .frame(maxWidth: 50, maxHeight: 50)
            .clipShape(Circle())
            .overlay(
                Circle().stroke(didFail ? .gray.opacity(0.5) : .white, lineWidth: 2.5)
            )
            .shadow(radius: 10)
    }
}
#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Location.self, configurations: config)
    
    return MapAnnotationView(url: Location.example.url)
        .modelContainer(container)
}
