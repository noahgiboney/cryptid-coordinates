//
//  NavigationImageStyle.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 1/26/24.
//

import SwiftUI


struct NavButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundStyle(Color.purple)
            .frame(width: 70, height: 70)
            .background(Color.black)
            .clipShape(Circle())
    }
}

extension View{
    func navButtonStyle() -> some View {
        modifier(NavButtonStyle())
    }
}
