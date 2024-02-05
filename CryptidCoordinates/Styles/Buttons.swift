//
//  NavigationImageStyle.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 1/26/24.
//

import SwiftUI

struct DarkButton: ViewModifier {
    
    var color: Color
    
    func body(content: Content) -> some View {
        content
            .foregroundStyle(color)
            .padding()
            .background(.ultraThickMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

extension View{
    func darkButtonStyle(foreground: Color) -> some View {
        modifier(DarkButton(color: foreground))
    }
}
