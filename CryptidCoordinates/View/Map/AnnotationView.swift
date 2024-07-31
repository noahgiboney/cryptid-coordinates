//
//  AnnotationView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 7/7/24.
//

import ClusterMap
import Kingfisher
import MapKit
import SwiftUI

struct AnnotationView: View {
    var url: URL?
    
    var body: some View {
        KFImage(url)
            .placeholder { _ in
                ZStack {
                    Circle().fill(.white)
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: "camera")
                }
            }
            .loadDiskFileSynchronously()
            .cacheMemoryOnly()
            .fade(duration: 0.25)
            .resizable()
            .frame(maxWidth: 50, maxHeight: 50)
            .clipShape(Circle())
            .overlay(
                Circle().stroke(Color.white, lineWidth: 2.5)
            )
            .shadow(radius: 10)
    }
}

#Preview {
    AnnotationView()
        .preferredColorScheme(.dark)
}
