//
//  TabBarView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/12/24.
//

import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView {
            Text("Home")
                .tabItem {
                    Image(systemName: "house")
                }
            
            Text("Map")
                .tabItem {
                    Image(systemName: "map")
                }
            
            Text("Profile")
                .tabItem {
                    Image(systemName: "person")
                }
        }
    }
}

#Preview {
    TabBarView()
}
