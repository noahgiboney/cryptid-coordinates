//
//  HomeView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/14/24.
//

import Firebase
import SwiftUI

struct HomeView: View {
    @Environment(UserViewModel.self) var userViewModel
    @Environment(\.colorScheme) var colorScheme
    @Namespace private var menuNamespace
    @State private var selection: MenuBarItem = .trending
    @State private var viewModel = ViewModel()
    @State private var isShowingSubmitLocationSheet = false
    
    var body: some View {
        MenuBarContainer(selection: $selection) {
            Text("1")
                .tabBarItem(tab: .trending, selection: $selection)
            
            Text("2")
                .tabBarItem(tab: .nearYou, selection: $selection)
            
            Text("2")
                .tabBarItem(tab: .topRated, selection: $selection)
        }
    }
}

#Preview {
    HomeView()
        .environment(UserViewModel())
}

extension HomeView {
    
    
    
    private var requestLocation: some View {
        VStack(spacing: 55) {
            Text("Know of a spooky spot that is not on our map? Submit a location to have it featured.")
            Button("Submit a location") {
                isShowingSubmitLocationSheet.toggle()
            }
        }
        .padding(.horizontal)
        .font(.footnote)
    }
}
