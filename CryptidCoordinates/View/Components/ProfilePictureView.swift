//
//  ProfilePictureView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/29/24.
//

import SwiftUI

enum ProfilePicType {
    case profile, editProfile, comment
    
    var size: CGFloat {
        switch self {
        case .profile:
            100
        case .editProfile:
            90
        case .comment:
            35
        }
        
    }
}

struct ProfilePictureView: View {
    var type: ProfilePicType
    var user: User
    @Environment(\.colorScheme) var scheme
    
    var body: some View {
        user.profilePicture.image
            .resizable()
            .scaledToFit()
            .foregroundStyle(scheme == .dark ? .white : .black)
            .frame(width: type.size, height: type.size)
    }
}

#Preview {
    ProfilePictureView(type: .profile, user: .example)
        .preferredColorScheme(.light)
}
