//
//  LeaderboardScreen.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 7/7/24.
//

import SwiftUI

struct LeaderboardScreen: View {
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
                        currentUserRowView
                    }
                    
                    Section {
                        ForEach(model.leaderboard.indices, id: \.self) { index in
                            NavigationLink {
                                UserProfileScreen(user: model.leaderboard[index])
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
    
    @ViewBuilder
    private var currentUserRowView: some View {
        if let index = model.leaderboard.firstIndex(where: { $0.id == global.user.id }){
            LeaderboardRowView(index: index)
        } else {
            HStack(spacing: 20) {
                Text("NA")
                    .font(.footnote)
                
                HStack {
                    AvatarView(type: .medium, user: global.user)
                    
                    Text(global.user.name)
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .font(.footnote)
                }
                
                Spacer()
                
                HStack(spacing: 4) {
                    Text("\(0)")
                        .contentTransition(.numericText())
                    Text("Visits")
                }
                .font(.caption2)
                .foregroundStyle(.gray)
            }
        }
    }
}

#Preview {
    LeaderboardScreen()
        .preferredColorScheme(.dark)
}
