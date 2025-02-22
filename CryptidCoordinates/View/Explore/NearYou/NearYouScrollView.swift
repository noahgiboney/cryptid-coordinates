//
//  NearYouScrollView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 9/8/24.
//

import CoreLocation
import SwiftUI

struct NearYouScrollView: View {
    let locations: [Location]
    var cords: CLLocationCoordinate2D
    @Environment(Global.self) var global
    @State private var sortedLocations: [Location] = []
    @State private var didSort = false
    
    var body: some View {
        Group {
            if didSort {
                VerticalLocationScrollView(locations: Array(sortedLocations.prefix(10)))
                
                Button {
                    global.tabSelection = .map
                } label: {
                    HStack(spacing: 5) {
                        Image(systemName: "map")
                        Text("View more on the map")
                    }
                    .font(.footnote)
                    .foregroundStyle(.accent)
                }
                .padding(.bottom)
                .frame(maxWidth: .infinity, alignment: .center)
                .buttonStyle(.borderless)
                
            } else {
                ProgressView()
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .onAppear {
            if !didSort {
                sortedLocations = locations.sorted { location1, location2 in
                    let distance1 = cords.distance(from: location1.clLocation)
                    let distance2 = cords.distance(from: location2.clLocation)
                    return distance1 < distance2
                }
                didSort = true
            }
        }
    }
}

#Preview {
    NearYouScrollView(locations: [], cords: .init())
}
