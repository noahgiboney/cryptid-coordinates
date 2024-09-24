//
//  LocationStore.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 9/6/24.
//

import Firebase
import Foundation

@Observable
class LocationStore {
    
    var trending: [String] = []
    var new: [NewLocation] = []
    
    func fetchTrendingLocations() async {
        do {
            let commentsSnapshot = try await Firestore.firestore().collectionGroup("comments").getDocuments()
            let locationIds = Set(commentsSnapshot.documents.compactMap { $0.reference.parent.parent?.documentID })
            
            trending = Array(locationIds).prefix(5).shuffled()
        } catch {
            print("Error: fetchTrending(): \(error.localizedDescription)")
        }
    }
    
    func fetchNewLocations() async {
        do {
            let actor = LocationActor()
            let fetchedNew: [NewLocation] = try await FirebaseService.shared.fetchData(ref: Collections.newLocations).sorted()
            
            await actor.setNewLocations(fetchedNew)
            
            try await withThrowingTaskGroup(of: (User?, String).self) { group in
                for location in fetchedNew {
                    group.addTask {
                        var user: User?
                        if let userId = location.userId {
                            user = try await self.fetchUser(with: userId)
                        }
                        return (user, location.id)
                    }
                }
                
                for try await (user, id) in group {
                    await actor.updateNewLocation(for: id, with: user)
                }
            }
            
            self.new = await actor.getNewLocations()
        } catch {
            print("Error: fetchNewLocations(): \(error.localizedDescription)")
        }
    }
    
    func fetchUser(with id: String) async throws -> User? {
        return try await FirebaseService.shared.fetchOne(id: id, ref: Collections.users)
    }
}

actor LocationActor {
    private var newLocations: [NewLocation] = []
    
    func setNewLocations(_ locations: [NewLocation]) {
        newLocations.append(contentsOf: locations)
    }
    
    func getNewLocations() -> [NewLocation] {
        newLocations
    }
    
    func updateNewLocation(for id: String, with user: User?) {
        if let index = newLocations.firstIndex(where: { $0.id == id }) {
            newLocations[index].user = user
        }
    }
}
