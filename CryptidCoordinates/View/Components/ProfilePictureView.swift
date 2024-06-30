//
//  ProfilePictureView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/29/24.
//

import SwiftUI

enum ProfilePicType {
    case profile, editProfile
    
    var size: CGFloat {
        switch self {
        case .profile:
            100
        case .editProfile:
            90
        }
    }
}

struct ProfilePictureView: View {
    @Environment(\.colorScheme) var scheme
    var type: ProfilePicType

    var body: some View {
        Image(.mask)
            .resizable()
            .scaledToFit()
            .foregroundStyle(scheme == .dark ? .white : .black)
            .frame(width: type.size, height: type.size)
    }
}

#Preview {
    ProfilePictureView(type: .profile)
        .preferredColorScheme(.light)
}
