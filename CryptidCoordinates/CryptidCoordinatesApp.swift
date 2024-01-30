//
//  CryptidCoordinatesApp.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 1/9/24.
//

import SwiftUI

@main
struct CryptidCoordinatesApp: App {
    
    // inject userFavorites into enviroment for all views
    @State private var userFavorites = UserFavorites()
    
    var body: some Scene {
        
        WindowGroup {
            ContentView()
                .environment(userFavorites)
        }
    }
}
