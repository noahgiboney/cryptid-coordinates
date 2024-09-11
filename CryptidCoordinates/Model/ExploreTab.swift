//
//  ExploreTab.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 9/6/24.
//

import Foundation

enum ExploreTab: Int, CaseIterable {
    case nearYou, trending, new
    
    var title: String {
        switch self {
        case .nearYou:
            "Near You"
        case .trending:
            "Trending"
        case .new:
            "New"
        }
    }
}

extension ExploreTab: Identifiable {
    var id: Int { self.rawValue }
}
