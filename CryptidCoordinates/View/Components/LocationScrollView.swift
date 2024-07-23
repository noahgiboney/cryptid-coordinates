//
//  LocationScrollView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 7/19/24.
//

import SwiftUI

struct LocationScrollView: View {
    var locations: [Location]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(locations) { location in
                    VStack(spacing: 10) {
                        FilteredImage(url: location.url, size: .scroll)
                            .containerRelativeFrame(.horizontal, count: 1, span: 1, spacing: 10)
                        
                        VStack(alignment: .leading) {
                            Text(location.name)
                                .font(.headline)
                            
                            Text(location.cityState)
                                .font(.footnote)
                        }
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .scrollTargetLayout()
                    .padding(.bottom)
                    .background(Color(uiColor: UIColor.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .scrollTransition { content, phase in
                        content
                            .opacity(phase.isIdentity ? 1.0 : 0.8)
                            .offset(y: phase.isIdentity ? 0 : 5)
                    }
                }
            }
        }
        .scrollTargetBehavior(.paging)
        .contentMargins(15, for: .scrollContent)
        .listRowInsets(EdgeInsets())
    }
}

#Preview {
    LocationScrollView(locations: [.example, .example, .example, .example, .example])
}
