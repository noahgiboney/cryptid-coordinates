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
        ZStack {
            Circle().fill(.white)
                .frame(width: 53, height: 53)
                .overlay(
                    Circle().stroke(.white, lineWidth: 2.5)
                )
                .shadow(radius: 10)
            
            if didFail || url == nil {
                Image(systemName: "eye.slash")
                    .imageScale(.large)
            } else {
                KFImage(url)
                    .onFailure({ _ in
                        DispatchQueue.main.async {
                            didFail = true
                        }
                    })
                    .placeholder({
                        ProgressView()
                    })
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    .shadow(radius: 10)
            }
        }
    }
}
#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Location.self, configurations: config)
    
    return MapAnnotationView(url: Location.example.url)
        .modelContainer(container)
}
