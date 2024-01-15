//
//  ContentView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 1/9/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView{
            MapView()
                .tabItem {
                    Image(systemName: "map")
                    Text("Map")
                }
            Text("Favoirtes Placeholder")
                .tabItem {
                    Image(systemName: "star")
                    Text("Favorites")
                }
        }
    }
}

#Preview {
    ContentView()
}
