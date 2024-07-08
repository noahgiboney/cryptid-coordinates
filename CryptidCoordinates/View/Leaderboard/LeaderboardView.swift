//
//  LeaderboardView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 7/7/24.
//

import SwiftUI

struct LeaderboardView: View {
    @State private var users: [User] = Array(repeating: .example, count: 10)
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(users.indices, id: \.self) { index in
                    HStack(spacing: 10) {
                        Text("\(index + 1)")
                            .font(.title2)
                        
                        HStack {
                            ProfilePictureView(type: .medium, user: users[index])
                            
                            Text(users[index].name)
                        }
                        
                        Spacer()
                        
                        Text("423 points")
                            .font(.footnote )
                            .foregroundStyle(.gray)
                    }
                }
            }
            .navigationTitle("Leaderboard")
        }
    }
}

#Preview {
    LeaderboardView()
}
