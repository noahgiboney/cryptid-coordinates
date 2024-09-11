//
//  VerticalLocationScrollView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 9/6/24.
//

import SwiftData
import SwiftUI

struct VerticalLocationScrollView: View {
    
    let locations: [Location]
    
    var body: some View {
        ForEach(locations) { location in
            VerticalLocationPreview(location: location)
                .background {
                    NavigationLink("", destination: LocationContainer(location: location))
                        .opacity(0)
                }
        }
        .padding(.top, 10)
        .listRowInsets(EdgeInsets())
        .padding(.bottom, 30)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Location.self, configurations: config)
    
    return VerticalLocationScrollView(locations: [.example])
        .modelContainer(container)
}
