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
            .foregroundStyle(.white)
            .frame(width: 70, height: 70)
            .background(.black)
            .clipShape(Circle())
    }
}

struct PreviewButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .foregroundStyle(.white)
            .background(.black)
            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
            .shadow(color: .gray, radius: 5)
    }
}

extension View{
    func navButtonStyle() -> some View {
        modifier(NavButtonStyle())
    }
    
    func previewButtomStyle() -> some View {
        modifier(PreviewButtonStyle())
    }
}
