//
//  LeaderboardModel.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 7/20/24.
//

import Firebase
import Foundation

@Observable
class Leaderboard {
    var users: [User] = []
    var isLoading = true
    var lastDocument: DocumentSnapshot?
    
    func populateInitalLeaderboard() async {

        defer { isLoading = false }
        
        do {
            let snapshot = try await queryLeaderboard()
                .getDocuments()
            
            users = snapshot.documents.compactMap { try? $0.data(as: User.self) }
            
            lastDocument = snapshot.documents.last
        } catch {
            print("Error: populateInitalLeaderboard(): \(error.localizedDescription)")
        }
    }
    
    func populateLeaderboard() async {
        guard let lastDocument = lastDocument else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let snapshot = try await queryLeaderboard()
                .start(afterDocument: lastDocument)
                .getDocuments()
            
            if snapshot.isEmpty {
                self.lastDocument = nil
                return
            }
            
            let snapshotUsers = snapshot.documents.compactMap { try? $0.data(as: User.self) }
            
            users.append(contentsOf: snapshotUsers)
            
            self.lastDocument = snapshot.documents.last
        } catch {
            print("Error: populateLeaderboard(): \(error.localizedDescription)")
        }
    }
    
    func refresh() async {
        await populateInitalLeaderboard()
    }
    
    private func queryLeaderboard() -> Query {
        return Collections.users
            .order(by: "visits", descending: true)
            .order(by: "name", descending: false)
            .whereField("visits", isNotEqualTo: 0)
            .limit(to: 10)
    }
}
