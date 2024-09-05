//
//  ProfilePicture.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/29/24.
//

import SwiftUI

enum Avatar: Codable, CaseIterable, Hashable {
    case killer, ghost, alien, skeleton, goblin, clown, reaper, satan, nun
    
    var cost: Int {
        switch self {
        case .killer:
            0
        case .ghost:
            5
        case .alien:
            10
        case .skeleton:
            15
        case .goblin:
            20
        case .clown:
            25
        case .reaper:
            30
        case .satan:
            35
        case .nun:
            40
        }
    }
    
    var image: Image {
        switch self {
        case .killer:
            Image(.killer)
        case .ghost:
            Image(.ghost)
        case .alien:
            Image(.alien)
        case .skeleton:
            Image(.skeleton)
        case .goblin:
            Image(.goblin)
        case .clown:
            Image(.clown)
        case .reaper:
            Image(.reaper)
        case .satan:
            Image(.satan)
        case .nun:
            Image(.nun)
        }
    }
    
    
}

enum AvatarSize {
    case profile, editProfile, comment, leaderboard, medium
    
    var size: CGFloat {
        switch self {
        case .profile:
            100
        case .editProfile:
            90
        case .comment:
            35
        case .leaderboard:
            20
        case .medium:
            40
        }
    }
}
