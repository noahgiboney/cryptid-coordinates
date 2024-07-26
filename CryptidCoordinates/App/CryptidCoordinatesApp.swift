//
//  CryptidCoordinatesApp.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 1/9/24.
//

import FirebaseCore
import SwiftData
import SwiftUI
import TipKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct CryptidCoordinatesApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    try? Tips.configure([
                        .displayFrequency(.immediate),
                        .datastoreLocation(.applicationDefault)])
                }
                .modelContainer(for: Location.self)
        }
    }
}
