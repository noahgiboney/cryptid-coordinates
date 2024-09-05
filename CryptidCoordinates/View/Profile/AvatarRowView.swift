//
//  AvatarRowView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 9/2/24.
//

import SwiftUI

struct AvatarRowView: View {
    var isSelected: Bool
    var avatar: Avatar
    var nsPfp: Namespace.ID
    @Environment(\.colorScheme) var scheme
    
    var body: some View {
        avatar.image
            .resizable()
            .scaledToFit()
            .foregroundStyle(.primary)
            .frame(width: 90, height: 90)
            .scaleEffect(isSelected ? 1.1 : 1)
            .overlay(alignment: .top) {
                if isSelected {
                    Image(systemName: "triangle.fill")
                        .rotationEffect(.degrees(180))
                        .matchedGeometryEffect(id: "PFP", in: nsPfp)
                        .offset(y: -30)
                }
            }
    }
}
