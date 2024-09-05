//
//  MedalView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 9/2/24.
//

import SwiftUI

struct MedalView: View {
    var index: Int
    
    var opacity: Double {
        switch index {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    var color: Color {
        switch index {
        case 0:
            return .gold
        case 1:
            return .silver
        case 2:
            return .bronze
        default:
            return .clear
        }
    }
    
    var body: some View {
        Group {
            if index < 3{
                Image(systemName: "medal.fill")
                    .opacity(opacity)
                    .foregroundStyle(color)
            } else {
                Text("\(index + 1)")
            }
        }
    }
}
