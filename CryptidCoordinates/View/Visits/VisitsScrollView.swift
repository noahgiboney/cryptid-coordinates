//
//  VisitsScrollView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 7/29/24.
//

import Firebase
import SwiftUI

enum SortOrder {
    case chronological, latest
}

struct VisitsScrollView: View {
    var visits: [Location : Timestamp]
    @State private var sortComparator: ((Dictionary<Location, Timestamp>.Element, Dictionary<Location, Timestamp>.Element) -> Bool) = { $0.value.dateValue() > $1.value.dateValue() }
    @State private var sortOrder: SortOrder = .latest
    
    var sortedVisits: [(key: Location, value: Timestamp)] {
        visits.sorted(by: sortComparator)
    }
    
    var body: some View {
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
        .toolbar {
            Menu("Sort", systemImage: "arrow.up.arrow.down") {
                Picker("Sort Order", selection: $sortOrder) {
                    Text("Latest First").tag(SortOrder.latest)
                    Text("Chronological").tag(SortOrder.chronological)
                }
            }
        }
        .onChange(of: sortOrder) {
            print(sortOrder)
            switch sortOrder {
            case .chronological:
                sortComparator = { $0.value.dateValue() < $1.value.dateValue() }
            case .latest:
                sortComparator = { $0.value.dateValue() > $1.value.dateValue() }
            }
        }
    }
}

#Preview {
    NavigationStack {
        VisitsScrollView(visits: [:])
    }
}
