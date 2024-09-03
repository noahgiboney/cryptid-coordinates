//
//  LeaderboardView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 7/7/24.
//

import SwiftUI

struct LeaderboardView: View {
    @Environment(GlobalModel.self) var global
    @State private var model = LeaderboardModel()
    @State private var didAppear = false
    
    var body: some View {
        NavigationStack {
            if model.isLoading && model.leaderboard.isEmpty {
                ProgressView {
                    Text("Loading")
                }
            } else {
                List {
                    Section {
                        if let index = model.leaderboard.firstIndex(where: { $0.id == global.user.id }){
                            LeaderboardRowView(index: index)
                        }
                    }
                    
                    Section {
                        ForEach(model.leaderboard.indices, id: \.self) { index in
                            NavigationLink {
                                UserProfileView(user: model.leaderboard[index])
                            } label: {
                                LeaderboardRowView(index: index)
                                    .onAppear {
                                        if model.leaderboard.last?.id == model.leaderboard[index].id {
                                            Task { await model.populateLeaderboard() }
                                        }
                                    }
                            }
                        }
                    }
                }
                .navigationTitle("Leaderboard")
            }
        }
        .environment(model)
        .task {
            guard !didAppear else { return }
            await model.populateInitalLeaderboard()
            didAppear = true
        }
    }
}

#Preview {
    LeaderboardView()
        .preferredColorScheme(.dark)
}
