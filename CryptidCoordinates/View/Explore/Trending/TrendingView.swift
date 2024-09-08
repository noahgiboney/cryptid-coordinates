//
//  TrendingView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 7/22/24.
//

import Firebase
import SwiftData
import SwiftUI

struct TrendingView: View {
    
    @Environment(LocationStore.self) var locations
    @State private var didLoad = false
    
    private func loadTrending() async {
        guard !didLoad else { return }
        await locations.fetchTrendingLocations()
        didLoad = true
    }
    
    var body: some View {
        ExploreTabContainer(title: "Trending", description: "The most popular locations") {
            TrendingScrollView(ids: locations.trending)
        }
        .listRowSeparator(.hidden)
        .task {
            await loadTrending()
        }
    }
}

struct TrendingScrollView: View {
    
    let ids: [String]
    @Query var locations: [Location]
    
    init(ids: [String]) {
        self.ids = ids
        _locations = .init(filter: #Predicate{ ids.contains($0.id) })
    }
    
    var body: some View {
        VerticalLocationScrollView(locations: locations)
    }
}

#Preview {
    TrendingView()
}
