//
//  TrendingScrollView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 9/7/24.
//

import SwiftData
import SwiftUI

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
    TrendingScrollView(ids: [])
}
