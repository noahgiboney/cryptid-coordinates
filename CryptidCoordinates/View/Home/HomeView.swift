//
//  HomeView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/14/24.
//

import Firebase
import SwiftUI

struct HomeView: View {
    @Environment(ViewModel.self) var viewModel
    @Environment(\.colorScheme) var colorScheme
    @Namespace private var menuNamespace
    @State private var selection: MenuBarItem = .trending
    @State private var isShowingMenu = false
    
    var body: some View {
        MenuBarContainer(isShowingMenu: $isShowingMenu, selection: $selection) {
            Text("1")
                .tabBarItem(tab: .trending, selection: $selection)
                .onAppear { isShowingMenu = false }
                .onDisappear { isShowingMenu = true }
            
            Text("2")
                .tabBarItem(tab: .nearYou, selection: $selection)
            
            Text("2")
                .tabBarItem(tab: .topRated, selection: $selection)
        }
    }
}

#Preview {
    HomeView()
        .preferredColorScheme(.dark)
        .environment(ViewModel(user: .example))
}

extension HomeView {
    
}
