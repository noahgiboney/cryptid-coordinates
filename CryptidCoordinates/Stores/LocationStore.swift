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
            new = try await FirebaseService.shared.fetchData(ref: Collections.newLocations).sorted()
            print(new.count)
            
            try await withThrowingTaskGroup(of: (User?, String).self) { group in
                for location in new {
                    group.addTask {
                        let user = try await self.fetchUser(with: location.userId)
                        return (user, location.id)
                    }
                }
                
                for try await (user, id) in group {
                    if let index = new.firstIndex(where: { $0.id == id}) {
                        new[index].user = user
                    }
                }
            }
        } catch {
            print("Error: new(): \(error.localizedDescription)")
        }
    }
    
    func fetchUser(with id: String) async throws -> User? {
        return try await FirebaseService.shared.fetchOne(id: id, ref: Collections.users)
    }
}
