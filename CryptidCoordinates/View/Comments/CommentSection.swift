//
//  CommentSection.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/22/24.
//

import Firebase
import SwiftUI

struct CommentSection: View {
    var location: Location
    @Environment(GlobalModel.self) var global
    @FocusState private var isFocused: Bool
    @State private var commentModel = CommentModel()
    
    var body: some View {
        VStack(spacing: 30) {
            HStack {
                TextEditor(text: $commentModel.comment)
                    .frame(minHeight: 50)
                    .fixedSize(horizontal: false, vertical: true)
                    .background(Color(UIColor.systemGray6), in: RoundedRectangle(cornerRadius: 15))
                    .overlay {
                        if commentModel.comment.isEmpty && !isFocused {
                            Text("Share an experience")
                                .fixedSize(horizontal: false, vertical: true)
                                .foregroundStyle(Color.gray.opacity(0.5))
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .onTapGesture {
                        isFocused = true
                    }
                    .focused($isFocused)
                    .onReceive(commentModel.comment.publisher.last()) {
                        if ($0 as Character).asciiValue == 10 {
                            isFocused = false
                            commentModel.comment.removeLast()
                        }
                    }
                    
                if !commentModel.comment.isEmpty {
                    Button(action: addComment, label: {
                        Image(systemName: "arrow.up.circle.fill")
                            .imageScale(.large)
                    })
                }
            }
            .padding(4)
            
            if !commentModel.comments.isEmpty  {
                LazyVStack(alignment: .leading, spacing: 25) {
                    ForEach(commentModel.comments) { comment in
                        CommentView(comment: comment)
                            .contextMenu {
                                if comment.userId == Auth.auth().currentUser?.uid {
                                    Button("Delete", systemImage: "trash", role: .destructive) {
                                        Task { try await commentModel.deleteComment(comment) }
                                    }
                                }
                            }
                    }
                }
                .padding(.trailing, 25)
            } else {
                VStack(spacing: 35){
                    Image(systemName: "bubble")
                        .foregroundStyle(.gray)
                        .scaleEffect(4.0)
                    Text("No comments yet")
                        .font(.title3.bold())
                }
                .padding(.vertical, 50)
            }
        }
        .padding(.horizontal)
        .task {
            try? await commentModel.fetchComments(locationId: location.id)
        }
    }
    
    func addComment() {
        Task {
            try await commentModel.addComment(locationId: location.id)
            isFocused = false
        }
    }
}

#Preview {
    CommentSection(location: Location.example)
        .environment(GlobalModel(user: .example))
}
