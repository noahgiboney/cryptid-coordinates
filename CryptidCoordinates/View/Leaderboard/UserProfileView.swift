//
//  UserProfileView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 8/5/24.
//

import Firebase
import SwiftData
import SwiftUI

struct UserProfileView: View {
    var user: User
    @Environment(\.modelContext) var modelContext
    @State private var visits: [Location : Timestamp] = [:]
    @State private var didLoad = false
    @State private var sortComparator: ((Dictionary<Location, Timestamp>.Element, Dictionary<Location, Timestamp>.Element) -> Bool) = { $0.value.dateValue() > $1.value.dateValue() }
    @State private var sortOrder: SortOrder = .latest
    
    var sortedVisits: [(key: Location, value: Timestamp)] {
        visits.sorted(by: sortComparator)
    }
    
    var body: some View {
        ScrollView {
            VStack {
                AvatarView(type: .profile, user: user)
                Text("Joined \(user.joinTimestamp.dateValue().formatted(date: .abbreviated, time: .omitted))")
                    .foregroundStyle(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.vertical)
            
            if didLoad {
                Group {
                    if sortedVisits.isEmpty {
                        ContentUnavailableView("No Visits Yet", systemImage: "house.lodge")
                    } else {
                        LazyVGrid(columns: [GridItem(), GridItem()]) {
                            ForEach(sortedVisits, id: \.key.id) { key, value in
                                VisitPreviewView(location: key, visitDate: value)
                            }
                        }
                    }
                }
                .padding(.horizontal, 5)
                .padding(.vertical)
            } else {
                ProgressView()
            }
        }
        .navigationTitle("\(user.name)")
        .navigationBarTitleDisplayMode(.large)
        .onChange(of: sortOrder) {
            print(sortOrder)
            switch sortOrder {
            case .chronological:
                sortComparator = { $0.value.dateValue() < $1.value.dateValue() }
            case .latest:
                sortComparator = { $0.value.dateValue() > $1.value.dateValue() }
            }
        }
        .task { try? await fetchUserVisits() }
    }
    
    func fetchUserVisits() async throws {
        do {
            var locationVisits: [Location : Timestamp] = [:]
            
            let userVisits = try await VisitService.shared.fetchVisits(userId: user.id)
            let locationIds = userVisits.compactMap { $0.locationId }
            
            let locations = try modelContext.fetch(FetchDescriptor(predicate: #Predicate<Location> {
                locationIds.contains($0.id)
            }))
            
            for visit in userVisits {
                if let index = locations.firstIndex(where: { $0.id == visit.locationId } ) {
                    locationVisits[locations[index]] = visit.timestamp
                }
            }
            
            visits = locationVisits
            didLoad = true
        } catch {
            print("Error: fetchUserVisits(): \(error.localizedDescription)")
        }
    }
}

#Preview {
    NavigationStack {
        UserProfileView(user: .example)
    }
}
