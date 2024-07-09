//
//  ProfilePicture.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/29/24.
//

import SwiftUI

enum Avatar: Codable, CaseIterable, Hashable {
    case person, killer, mummy, spider, vampire, scream, satan, nun
    
    var cost: Int {
        switch self {
        case .person:
            0
        case .killer:
            0
        case .mummy:
            5
        case .spider:
            10
        case .vampire:
            15
        case .scream:
            25
        case .satan:
            35
        case .nun:
            50
        }
    }
    
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
        case .satan:
            Image(.satan)
        }
    }
}
