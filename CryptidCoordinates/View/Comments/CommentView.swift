//
//  CommentView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/18/24.
//

import Firebase
import SwiftUI

struct CommentView: View {
    var comment: Comment
    @Environment(GlobalModel.self) var viewModel
    
    var body: some View {
        Group {
            if let user = comment.user {
                HStack(alignment: .top){
                    AvatarView(type: .comment, user: user)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        HStack(alignment: .bottom) {
                            Text(user.name)
                                .fontWeight(.semibold)
                            
                            Text(comment.timestamp.timeAgo())
                                .font(.caption)
                                .foregroundStyle(.gray)
                        }
                        
                        Text(comment.content)
                            .font(.footnote)
                    }
                }
            }
        }
    }
}

#Preview {
    CommentView(comment: .example)
        .environment(GlobalModel(user: .example, defaultCords: Location.example.coordinates))
}
