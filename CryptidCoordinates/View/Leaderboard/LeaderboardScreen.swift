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
                        ForEach(model.leaderboard) { user in
                            if let index = model.leaderboard.firstIndex(where: { $0.id == user.id }){
                                Group {
                                    if user.id == global.user.id {
                                        currentUserRowView
                                    } else {
                                        NavigationLink {
                                            UserProfileScreen(user: user)
                                        } label: {
                                            LeaderboardRowView(user: user, index: index)
                                            
                                        }
                                    }
                                }
                                .onAppear {
                                    if model.leaderboard.last?.id == user.id {
                                        Task { await model.populateLeaderboard() }
                                    }
                                }
                            }
                        }
                    }
                }
                .navigationTitle("Leaderboard")
                .refreshable {
                    Task { await model.refresh() }
                }
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
        let index = model.leaderboard.firstIndex(where: { $0.id == global.user.id })
        
        HStack(spacing: 20) {
            
            let visits = global.user.visits
            
            if let index = index {
                MedalView(index: index)
            } else {
                Text("NA")
            }
            
            HStack {
                AvatarView(type: .medium, user: global.user)
                
                Text(global.user.name)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .font(.footnote)
            }
            
            Spacer()
            
            HStack(spacing: 4) {
                Text("\(visits)")
                    .contentTransition(.numericText())
                Text("Visits")
            }
            .font(.caption2)
            .foregroundStyle(.gray)
        }
        .padding(.leading, index ?? 0 > 2 && index != 9 ? 9 : 0)
        .padding(.leading, index == 9 ? 3 : 0)
    }
}

#Preview {
    LeaderboardScreen()
        .preferredColorScheme(.dark)
}
