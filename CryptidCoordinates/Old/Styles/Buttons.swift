//
//  NavigationImageStyle.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 1/26/24.
//

import SwiftUI

struct DarkLabel: ViewModifier {
    
    var color: Color
    
    func body(content: Content) -> some View {
        content
            .foregroundStyle(color)
            .padding()
            .background(.ultraThickMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct AnimatedButton : ButtonStyle{
    func makeBody(configuration: Configuration) -> some View {
        configuration.label.scaleEffect(configuration.isPressed ? 1.3 : 1.0)
    }
}

extension View{
    func darkLabelStyle(foreground: Color) -> some View {
        modifier(DarkLabel(color: foreground))
    }
}
