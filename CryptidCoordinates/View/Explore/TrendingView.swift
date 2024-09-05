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
    @Environment(\.modelContext) var modelContext
    @State private var trendingIds: [String] = []
    @State private var trendingLocations: [Location] = []
    @State private var didAppear = false
    
    private func fetchLocations() throws {
        let descriptor = FetchDescriptor<Location>(predicate: #Predicate<Location> { location in
            trendingIds.contains(location.id)
        }, sortBy: [SortDescriptor(\Location.name)])
        
        let locations = try modelContext.fetch(descriptor)
        trendingLocations = locations
    }
    
    private func fetchTrendingLocations() async {
        guard !didAppear else { return }
        
        do {
            let commentsSnapshot = try await Firestore.firestore().collectionGroup("comments").getDocuments()
            let locationIds = Set(commentsSnapshot.documents.compactMap { $0.reference.parent.parent?.documentID })
            print(locationIds)
            trendingIds = Array(locationIds).prefix(5).shuffled()
            
            try fetchLocations()
        } catch {
            print("Error: fetchTrendingLocations(): \(error.localizedDescription)")
        }
    }
    
    var body: some View {
        LocationScrollView(locations: trendingLocations)
            .listRowInsets(EdgeInsets())
            .task {
                await fetchTrendingLocations()
                didAppear = true
            }
    }
}

#Preview {
    TrendingView()
}
