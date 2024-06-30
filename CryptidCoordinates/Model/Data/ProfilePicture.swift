//
//  ProfilePicture.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/29/24.
//

import SwiftUI

enum ProfilePicture: Codable, CaseIterable, Hashable {
    case person, killer, nun , mummy, spider, scream, vampire
    
    var image: Image {
        switch self {
        case .killer:
            Image(.killer)
        case .nun:
            Image(.nun)
        case .spider:
            Image(.spider)
        case .scream:
            Image(.scream)
        case .person:
            Image(.person)
        case .vampire:
            Image(.vampire)
        case .mummy:
            Image(.mummy)
        }
    }
}
