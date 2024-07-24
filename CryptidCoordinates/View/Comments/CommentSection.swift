//
//  CommentSection.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/22/24.
//

import Firebase
import SwiftUI

struct CommentSection: View {
    var locationId: String
    @Environment(GlobalModel.self) var global
    @FocusState private var isFocused: Bool
    @State private var model = CommentModel()
    
    var body: some View {
        VStack(spacing: 30) {
            textField
            
            switch model.loadState {
            case .loaded:
                commentScrollView
            case .loading:
                ProgressView()
            case .empty:
                Label("Be the first", systemImage: "bubble")
                    .padding(.bottom, 50)
                    .foregroundStyle(.gray)
            }
        }
        .padding(.horizontal)
        .onChange(of: model.comments) { oldValue, newValue in
            if !model.comments.isEmpty {
                model.loadState = .loaded
            }
        }
        .task {
            try? await model.fetchComments(locationId: locationId)
        }
    }
    
    var commentScrollView: some View {
        LazyVStack(alignment: .leading, spacing: 25) {
            ForEach(model.comments) { comment in
                CommentView(comment: comment)
                    .contextMenu {
                        if comment.userId == Auth.auth().currentUser?.uid {
                            Button("Delete", systemImage: "trash", role: .destructive) {
                                Task { try await model.deleteComment(comment) }
                            }
                        }
                    }
            }
        }
        .padding(.trailing, 25)
        .padding(.bottom, 50)
    }
    
    var textField: some View {
        HStack(alignment: .bottom) {
            TextEditor(text: $model.comment)
                .frame(minHeight: 40)
                .fixedSize(horizontal: false, vertical: true)
                .scrollContentBackground(.hidden)
                .overlay {
                    if model.comment.isEmpty && !isFocused {
                        Text("Share an experience")
                            .fixedSize(horizontal: false, vertical: true)
                            .foregroundStyle(Color.gray.opacity(0.5))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 10)
                    }
                }
                .onTapGesture {
                    isFocused = true
                }
                .focused($isFocused)
                .onReceive(model.comment.publisher.last()) {
                    if ($0 as Character).asciiValue == 10 {
                        isFocused = false
                        model.comment.removeLast()
                    }
                }
                
            if !model.comment.isEmpty {
                Button(action: addComment, label: {
                    Image(systemName: "arrow.up.circle.fill")
                        .imageScale(.large)
                })
                .padding(.bottom, 5)
            }
        }
        .padding(.horizontal, 10)
        .background(Color(uiColor: .systemFill), in: RoundedRectangle(cornerRadius: 15))
    }
    
    func addComment() {
        Task {
            try await model.addComment(locationId: locationId)
            isFocused = false
        }
    }
}

#Preview {
    
    
    CommentSection(locationId: UUID().uuidString)
        .environment(GlobalModel(user: .example))
}
