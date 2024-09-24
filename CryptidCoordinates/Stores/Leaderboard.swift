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
    var didAppear = false
    
    func loadLeaderboard() async {
        if didAppear {
            await populateUpToLastDoc()
        } else {
            await populateInitalLeaderboard()
        }
    }
    
    @MainActor
    func populateInitalLeaderboard() async {
        defer { isLoading = false }
        
        do {
            let snapshot = try await queryLeaderboard().getDocuments()
            
            users = snapshot.documents.compactMap { try? $0.data(as: User.self) }
            
            lastDocument = snapshot.documents.last
            didAppear.toggle()
        } catch {
            print("Error: populateInitalLeaderboard(): \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func populateUpToLastDoc() async {
        guard let lastDoc = lastDocument else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let snapshot = try await queryLeaderboard().end(atDocument: lastDoc).getDocuments()
            
            users = snapshot.documents.compactMap { try? $0.data(as: User.self) }
            
            lastDocument = snapshot.documents.last
        } catch {
            print("Error: populateUpToLastDoc(): \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func paginateLeaderboard() async {
        guard !isLoading else { return }
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
    
    @MainActor
    private func queryLeaderboard() -> Query {
        return Collections.users
            .order(by: "visits", descending: true)
            .order(by: "name", descending: false)
            .whereField("visits", isNotEqualTo: 0)
            .limit(to: 10)
    }
}
