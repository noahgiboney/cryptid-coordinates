//
//  ProfilePictureView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/29/24.
//

import SwiftUI

struct AvatarView: View {
    
    let type: AvatarSize
    let user: User
    @Environment(\.colorScheme) var scheme
    
    var body: some View {
        user.avatar.image
            .resizable()
            .scaledToFit()
            .foregroundStyle(scheme == .dark ? .white : .black)
            .frame(width: type.size, height: type.size)
    }
}

#Preview {
    AvatarView(type: .profile, user: .example)
        .preferredColorScheme(.dark)
}
