//
//  LeadboardRowView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 9/2/24.
//

import SwiftUI

struct LeaderboardRowView: View {
    
    let user: User
    let index: Int
    
    var body: some View {
        HStack(spacing: 20) {
            MedalView(index: index)
            
            HStack {
                AvatarView(type: .medium, user: user)
                
                Text(user.username)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .font(.footnote)
            }
            
            Spacer()
            
            HStack(spacing: 4) {
                Text("\(user.visits)")
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

#Preview {
    LeaderboardRowView(user: .example, index: 1)
}
