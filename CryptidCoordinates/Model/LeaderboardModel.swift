//
//  LeaderboardModel.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 7/20/24.
//

import Foundation

@Observable
class LeaderboardModel {
    var leaderboard: [User] = []
    var didLoad = false
    
    func fetchLeadboard() async throws {
        do {
            leaderboard = try await VisitService.shared.fetchLeaderboard()
            didLoad = true
        } catch {
            print("Error: fetchLeadboard(): \(error.localizedDescription)")
        }
    }
}
