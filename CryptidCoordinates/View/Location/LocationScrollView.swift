//
//  LocationScrollView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 7/19/24.
//

import Kingfisher
import SwiftData
import SwiftUI

struct LocationScrollView: View {
    var locations: [Location]
    @EnvironmentObject var locationManager: LocationManager
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack {
                ForEach(locations) { location in
                    NavigationLink {
                        LocationView(location: location)
                    } label: {
                        LocationPreviewView(location: location)
                    }
                }
            }
        }
        .contentMargins(15, for: .scrollContent)
        .listRowInsets(EdgeInsets())
    }
}

#Preview {
    LocationScrollView(locations: [.example, .example, .example, .example, .example])
        .environmentObject(LocationManager())
}
