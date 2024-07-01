//
//  CommentSection.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/22/24.
//

import SwiftUI

struct CommentSection: View {
    @Environment(ViewModel.self) var viewModel
    @FocusState private var isFocused: Bool
    @State private var comment = ""
    let location: Location
    
    var body: some View {
        VStack(spacing: 30) {
            Text("156 comments")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                TextEditor(text: $comment)
                    .frame(minHeight: 50)
                    .fixedSize(horizontal: false, vertical: true)
                    .overlay {
                        if comment == "" && !isFocused {
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
                    .onReceive(comment.publisher.last()) {
                        if ($0 as Character).asciiValue == 10 {
                            isFocused = false
                            comment.removeLast()
                        }
                    }
                    
                
                if !comment.isEmpty {
                    Button(action: addComment, label: {
                        Image(systemName: "arrow.up.circle.fill")
                            .imageScale(.large)
                    })
                }
            }
            .padding(4)
            
            LazyVStack(alignment: .leading, spacing: 25) {
                ForEach(0..<10) { _ in
                    CommentView(comment: Comment.example)
                }
            }
        }
        .padding(.horizontal)
    }
    
    private func addComment() {
        Task {
            try await viewModel.addComment(content: comment, locationId: location.id)
            comment = ""
            isFocused  = false
        }
    }
}

#Preview {
    CommentSection(location: Location.example)
        .environment(ViewModel(user: .example))
}
