//
//  LocationScrollView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 7/19/24.
//

import Kingfisher
import SwiftData
import SwiftUI

struct HorizontalLocationScrollView: View {
    
    let title: String
    let locations: [Location]
    @EnvironmentObject var locationManager: LocationManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.title2.bold())
                .padding(.leading)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach(locations) { location in
                        NavigationLink {
                            LocationScreen(location: location)
                        } label: {
                            LocationPreviewView(location: location)
                        }
                    }
                }
            }
        }
        .contentMargins(15, for: .scrollContent)
        .listRowInsets(EdgeInsets())
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Location.self, configurations: config)
    
    return HorizontalLocationScrollView(title: "Test", locations: [.example, .example3, .example2])
        .modelContainer(container)
        .environmentObject(LocationManager())
}
