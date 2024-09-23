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
        }
        .listRowInsets(EdgeInsets())
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Location.self, configurations: config)
    
    return VerticalLocationScrollView(locations: [.example])
        .modelContainer(container)
}
