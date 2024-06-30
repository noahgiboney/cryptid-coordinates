//
//  CommentView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/18/24.
//

import Firebase
import SwiftUI

struct CommentView: View {
    let comment: Comment
    
    var body: some View {
        HStack {
            ProfilePictureView(type: .comment, user: .example)
            
            VStack(alignment: .leading, spacing: 5) {
                HStack(alignment: .bottom) {
                    Text(comment.userName)
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

#Preview {
    CommentView(comment: .example)
}

extension Timestamp {
    func timeAgo() -> String {
        let now = Date()
        let timeInterval = now.timeIntervalSince(self.dateValue())
        
        let minute: Double = 60
        let hour: Double = 3600
        let day: Double = 86400
        let week: Double = 604800
        
        if timeInterval < minute {
            return "\(Int(timeInterval))s"
        } else if timeInterval < hour {
            return "\(Int(timeInterval / minute))m"
        } else if timeInterval < day {
            return "\(Int(timeInterval / hour))h"
        } else if timeInterval < week {
            return "\(Int(timeInterval / day))d"
        } else {
            return "\(Int(timeInterval / week))w"
        }
    }
}
