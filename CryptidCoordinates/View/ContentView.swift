//
//  ContentView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/12/24.
//

import FirebaseFirestore
import FirebaseCore
import SwiftData
import SwiftUI

struct ContentView: View {
    @AppStorage("isContextPopulated") var isContextPopulated = false
    @Environment(\.modelContext) var modelContext
    @State private var authModel = AuthModel()
    
    var body: some View {
        Group {
            if authModel.userSession != nil {
                if let user = authModel.currentUser {
                    TabBarView(currentUser: user)
                }
            } else {
                LandingView()
            }
        }
        .environment(authModel)
        .onAppear {
            if !isContextPopulated {
                populateModelContext()
            }
        }
    }
    
    func populateModelContext() {
        let locations = Bundle.main.decode(file: "locationData.json")
        
        locations.forEach { location in
            let newLocation = Location(
                id: location.id,
                name: location.name,
                country: location.country,
                city: location.city,
                state: location.state,
                detail: location.detail,
                longitude: location.longitude,
                latitude: location.latitude,
                cityLongitude: location.cityLongitude,
                cityLatitude: location.cityLatitude,
                stateAbbrev: location.stateAbbrev,
                imageUrl: location.imageUrl,
                geohash: location.geohash
            )
            
            modelContext.insert(newLocation)
        }
        isContextPopulated = true
    }
    
    func wipeModelContext() {
        do {
            try modelContext.delete(model: Location.self)
        } catch {
            fatalError("Error: wipeModelContext(): \(error.localizedDescription)")
        }
    }
}

#Preview {
    ContentView()
}
