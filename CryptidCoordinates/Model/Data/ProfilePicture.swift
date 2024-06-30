//
//  ProfilePicture.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/29/24.
//

import SwiftUI

enum ProfilePicture: Codable, CaseIterable {
    case killer, mummy ,mask, spider, scream, vampire ,person
    
    var image: Image {
        switch self {
        case .killer:
            Image(.killer)
        case .mask:
            Image(.mask)
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
