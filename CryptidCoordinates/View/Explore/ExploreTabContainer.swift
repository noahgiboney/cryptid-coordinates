//
//  ExploreTabContainer.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 9/7/24.
//

import SwiftUI

struct ExploreTabContainer<Content: View>: View {
    
    let title: String
    let description: String
    let content: Content
    
    init(title: String, description: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.description = description
        self.content = content()
    }
    
    var body: some View {
        Section {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.title2.bold())
                Text(description)
                    .foregroundStyle(.gray)
                    .font(.system(size: 15))
            }
        }
        .listRowSeparator(.hidden)
        
        content
    }
}

#Preview {
    ExploreTabContainer(title: "Near You", description: "Haunted Locations Near You") {
        VStack {
            
        }
    }
}
