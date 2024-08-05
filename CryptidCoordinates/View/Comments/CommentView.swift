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
    var model: CommentModel
    @Environment(GlobalModel.self) var viewModel
    @State private var showingReportAlert = false
    @State private var showingDeleteConfirm = false
    
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
                    
                    Spacer()
                    
                    VStack {
                        Spacer()
                        Menu {
                            if comment.userId == Auth.auth().currentUser?.uid {
                                Button("Delete", systemImage: "trash", role: .destructive) {
                                    showingDeleteConfirm.toggle()
                                }
                            }
                            
                            Button("Report", systemImage: "flag") {
                                Task {
                                    try await model.reportComment(comment)
                                    showingReportAlert.toggle()
                                }
                            }
                        } label: {
                            Image(systemName: "ellipsis")
                                .imageScale(.large)
                                .foregroundStyle(.gray)
                        }
                        Spacer()
                    }
                }
            }
        }
        .alert("Comment Report", isPresented: $showingReportAlert) {
        } message: {
            Text("Thank you for reporting this comment, it will be reviewed shortly.")
        }
        .confirmationDialog("Delete Comment", isPresented: $showingDeleteConfirm) {
            Button("Delete Comment", systemImage: "trash", role: .destructive) {
                Task { try await model.deleteComment(comment) }
            }
        }

    }
}

#Preview {
    CommentView(comment: .example, model: CommentModel())
        .environment(GlobalModel(user: .example, defaultCords: Location.example.coordinates))
}
