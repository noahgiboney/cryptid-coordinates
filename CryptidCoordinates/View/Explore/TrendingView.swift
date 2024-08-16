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
    @State private var didAppear = false
    
    var body: some View {
        LocationScrollView(locations: trendingLocations)
            .listRowInsets(EdgeInsets())
            .task { 
                await fetchTrendingLocations()
                didAppear = true
            }
    }
    
    func fetchLocations() throws {
        let descriptor = FetchDescriptor<Location>(predicate: #Predicate<Location> { location in
            trendingIds.contains(location.id)
        }, sortBy: [SortDescriptor(\Location.name)])
        
        let locations = try modelContext.fetch(descriptor)
        trendingLocations = locations
    }
    
    func fetchTrendingLocations() async {
        guard !didAppear else { return }
        
        do {
            trendingIds = try await CommentService.shared.fetchLocationIdsWithComments()
            try fetchLocations()
        } catch {
            print("Error: fetchTrendingLocations(): \(error.localizedDescription)")
        }
    }
}

#Preview {
    TrendingView()
}
