//
//  Menu.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/21/24.
//

import SwiftUI

enum MenuBarItem: Hashable {
    case trending, nearYou, topRated
}

struct MenuBarContainer<Content: View>: View {
    @Binding var selection: MenuBarItem
    var content: () -> Content
    
    init(selection: Binding<MenuBarItem>, @ViewBuilder content: @escaping () -> Content) {
        self._selection = selection
        self.content = content
    }
    
    var body: some View {
        ZStack{
            content()
            
            VStack {
                Spacer()
                MenuBar(selection: $selection)
            }
        }
    }
}

struct MenuBar: View {
    @Binding var selection: MenuBarItem
    @Namespace var menuNamespace
    
    var body: some View {
        HStack(spacing: 10){
            menuButton(text: "Trending", isSelected: selection == .trending) {
                withAnimation {
                    selection = .trending
                }
                
            }
            
            menuButton(text: "Near You", isSelected: selection == .nearYou) {
                withAnimation {
                    selection = .nearYou
                }
                
            }
            
            menuButton(text: "Top", isSelected: selection == .topRated) {
                withAnimation {
                    selection = .topRated
                }
                
            }
        }
        .background(Capsule()
            .fill(.ultraThickMaterial)
                    // .fill(colorScheme == .dark ? .gray.opacity(0.9) : .gray.opacity(0.8))
            .frame(width: 290, height: 45))
        .padding(.bottom)
    }
    
    func menuButton(text: String, isSelected: Bool, action: @escaping () -> Void) -> some View{
        Button(action: action, label: {
            if isSelected {
                Text(text)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 3)
                    .background(
                        Capsule().fill(.gray.opacity(0.6)).matchedGeometryEffect(id: "menu", in: menuNamespace))
            } else {
                Text(text)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 3)
            }
        })
        .font(.headline)
        .buttonStyle(.plain)
        .foregroundStyle(isSelected ? .white : .gray)
    }
}

#Preview {
    MenuBar(selection: .constant(.nearYou))
}

struct MenuItemsPreferenceKey: PreferenceKey {
    static var defaultValue: [MenuBarItem] = []
    
    static func reduce(value: inout [MenuBarItem], nextValue: () -> [MenuBarItem]) {
        value += nextValue()
    }
}

struct TabBarItemViewModifier: ViewModifier {
    let tab: MenuBarItem
    @Binding var selection: MenuBarItem

    func body(content: Content) -> some View {
    content
        .opacity(selection == tab ? 1.0 : 0.0)
        .preference(key: MenuItemsPreferenceKey.self, value: [tab])
    }
}

extension View {
    func tabBarItem(tab: MenuBarItem, selection: Binding<MenuBarItem>) -> some View {
    self.modifier(TabBarItemViewModifier(tab: tab, selection: selection))
    }
}
