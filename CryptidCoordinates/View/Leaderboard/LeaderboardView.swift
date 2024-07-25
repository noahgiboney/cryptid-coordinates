//
//  LeaderboardView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 7/7/24.
//

import SwiftUI

struct LeaderboardView: View {
    @State private var model = LeaderboardModel()
    
    var body: some View {
        NavigationStack {
            if model.didLoad {
                List {
                    ForEach(model.leaderboard.indices, id: \.self) { index in
                        HStack(spacing: 20) {
                            MedalView(index: index)
                            
                            HStack {
                                AvatarView(type: .medium, user: model.leaderboard[index])
                                
                                Text(model.leaderboard[index].name)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                            }
                            
                            Spacer()
                            
                            HStack(spacing: 4) {
                                Text("\(model.leaderboard[index].visits)")
                                    .contentTransition(.numericText())
                                Text("Visits")
                            }
                            .font(.caption2)
                            .foregroundStyle(.gray)
                        }
                        .padding(.leading, index > 2 && index != 9 ? 9 : 0)
                        .padding(.leading, index == 9 ? 3 : 0)
                    }
                }
                .navigationTitle("Leaderboard")
            } else {
                LoadingView()
            }
        }
        .task { try? await model.fetchLeadboard() }
    }
}

#Preview {
    LeaderboardView()
        .preferredColorScheme(.dark)
}

struct MedalView: View {
    var index: Int
    
    var opacity: Double {
        switch index {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    var color: Color {
        switch index {
        case 0:
            return .gold
        case 1:
            return .silver
        case 2:
            return .bronze
        default:
            return .clear
        }
    }
    
    var body: some View {
        Group {
            if index < 3{
                Image(systemName: "medal.fill")
                    .opacity(opacity)
                    .foregroundStyle(color)
            } else {
                Text("\(index + 1)")
            }
        }
    }
}
