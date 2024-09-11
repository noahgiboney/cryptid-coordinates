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
            if didLoad {
                TrendingScrollView(ids: locations.trending)
            } else {
                ProgressView()
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .listRowSeparator(.hidden)
        .task {
            await loadTrending()
        }
    }
}

#Preview {
    TrendingView()
}
