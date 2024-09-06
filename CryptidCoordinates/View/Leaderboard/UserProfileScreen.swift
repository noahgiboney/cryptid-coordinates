//
//  UserProfileScreen.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 8/5/24.
//

import Firebase
import SwiftData
import SwiftUI

struct UserProfileScreen: View {
    
    let user: User
    @Environment(\.modelContext) var modelContext
    @Environment(VisitStore.self) var visitStore
    @State private var visits: [Location : Timestamp] = [:]
    @State private var didLoad = false
    @State private var sortComparator: ((Dictionary<Location, Timestamp>.Element, Dictionary<Location, Timestamp>.Element) -> Bool) = { $0.value.dateValue() > $1.value.dateValue() }
    @State private var sortOrder: SortOrder = .latest
    
    private var sortedVisits: [(key: Location, value: Timestamp)] {
        visits.sorted(by: sortComparator)
    }
    
    private func fetchUserVisits() async {
        do {
            let userVisits = try await visitStore.fetchVisits(for: user.id)
            let locationIds = userVisits.compactMap { $0.locationId }
            
            let locations = try modelContext.fetch(FetchDescriptor(predicate: #Predicate<Location> {
                locationIds.contains($0.id)
            }))
            
            visits = visitStore.mapVisits(locations: locations, visits: userVisits)
            didLoad = true
        } catch {
            print("Error: fetchUserVisits(): \(error.localizedDescription)")
        }
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
        .task { await fetchUserVisits() }
    }
}

#Preview {
    NavigationStack {
        UserProfileScreen(user: .example)
            .environment(VisitStore())
    }
}
