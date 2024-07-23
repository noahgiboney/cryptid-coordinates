//
//  TrendingView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 7/22/24.
//

import SwiftData
import SwiftUI

struct TrendingView: View {
    @Environment(\.modelContext) var modelContext
    @State private var trendingIds: [String] = []
    @State private var trendingLocations: [Location] = []
    
    var body: some View {
        LocationScrollView(locations: trendingLocations)
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets())
            .task {
                await fetchTrending()
            }
    }
    
    func fetchTrending() async {
        do {
            trendingIds = try await LocationService.shared.fetchTrending()
            try fetchLocations()
        } catch {
            print("Error: fetchTrending(): \(error.localizedDescription)")
        }
    }
    
    func fetchLocations() throws {
        let descriptor = FetchDescriptor<Location>(predicate: #Predicate<Location> { location in
            trendingIds.contains(location.id)
        }, sortBy: [SortDescriptor(\Location.name)])
        
        let locations = try modelContext.fetch(descriptor)
        trendingLocations = locations
    }
}

#Preview {
    TrendingView()
}
