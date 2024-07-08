//
//  LocationUpdater.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/30/24.
//

import Foundation
import SwiftUI
import FirebaseFirestore

@MainActor
class UpdateService {
    let db = Firestore.firestore()
    
    func updateLocationsWithImageUrl() async throws {
        let locations = try await fetchLocations()
        var updateCount = 0
        
        for var location in locations.shuffled() {
            
//            if location.imageUrl != nil {
//                updateCount += 1
//                print(updateCount)
//            }
            
            if location.imageUrl == nil {
                if let imageUrl = try await GoogleImageService.shared.fetchImageUrl(for: location.name + " " + location.city + " haunted") {
                    location.imageUrl = imageUrl
                    location.stats = LocationStats(likes: 0, comments: 0)
                    if location.imageUrl != nil {
                        try await updateLocationInFirebase(location)
                        updateCount += 1
                        print(updateCount)
                        print("updated: \(location.id)")
                    }
                   
                }
            }
        }
    }
    
    private func fetchLocations() async throws -> [Location] {
        let snapshot = try await db.collection("locations").getDocuments()
        return snapshot.documents.compactMap { document in
            try? document.data(as: Location.self)
        }
    }
    
    private func updateLocationInFirebase(_ location: Location) async throws {
        let docRef = db.collection("locations").document(location.id)
        try docRef.setData(from: location, merge: true)
    }
}

@MainActor
class LocationUpdateManager: ObservableObject {
    @Published var isUpdating = false
    @Published var errorMessage: String?
    
    func updateLocations() {
        isUpdating = true
        errorMessage = nil
        
        Task {
            do {
                let updater = UpdateService()
                try await updater.updateLocationsWithImageUrl()
                DispatchQueue.main.async {
                    self.isUpdating = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to update locations: \(error)"
                    self.isUpdating = false
                }
            }
        }
    }
}

struct UpdateView: View {
    @StateObject private var locationUpdateManager = LocationUpdateManager()
    
    var body: some View {
        VStack {
            if locationUpdateManager.isUpdating {
                ProgressView("Updating locations...")
            } else {
                Button(action: {
                    locationUpdateManager.updateLocations()
                }) {
                    Text("Update Locations")
                }
            }
            
            if let errorMessage = locationUpdateManager.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
        }
        .padding()
        .task {
            locationUpdateManager.updateLocations()
        }
    }
}
