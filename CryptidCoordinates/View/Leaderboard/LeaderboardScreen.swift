//
//  LeaderboardScreen.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 7/7/24.
//

import SwiftUI

struct LeaderboardScreen: View {
    
    @Environment(Global.self) var global
    @State private var leaderboard = Leaderboard()
    
    var body: some View {
        NavigationStack {
            List {
                Section("Your Ranking") {
                    currentUserRowView
                }
                
                Section {
                    ForEach(leaderboard.users) { user in
                        if let index = leaderboard.users.firstIndex(where: { $0.id == user.id }) {
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
                            .id(user.id)
                        }
                    }
                    
                    if leaderboard.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity, alignment: .center)
                            .listRowBackground(Color.clear)
                    }
                }
                
                Color.clear
                    .listRowBackground(Color.clear)
                    .onAppear {
                        Task { await leaderboard.paginateLeaderboard() }
                    }
            }
            .navigationTitle("Leaderboard")
            
        }
        .environment(leaderboard)
        .task {
            await leaderboard.loadLeaderboard()
        }
    }
    
    @ViewBuilder
    private var currentUserRowView: some View {
        let index = leaderboard.users.firstIndex(where: { $0.id == global.user.id })
        
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
