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
    var scrollProxy: ScrollViewProxy
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
                    .foregroundStyle(.gray)
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 35)
        .onChange(of: model.comments) { oldValue, newValue in
            if !model.comments.isEmpty {
                model.loadState = .loaded
            }
        }
        .task {
            try? await model.fetchComments(locationId: locationId)
        }
        .onChange(of: isFocused) { _, newValue in
            if newValue == true {
                withAnimation {
                    scrollProxy.scrollTo("text_field")
                }
            }
        }
    }
    
    var commentScrollView: some View {
        LazyVStack(alignment: .leading, spacing: 25) {
            ForEach(model.comments) { comment in
                CommentView(comment: comment)
                    .id(comment.id)
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
    }
    
    var textField: some View {
            HStack(alignment: .bottom) {
                TextEditor(text: $model.comment)
                    .id("text_field")
                    .frame(minHeight: 40)
                    .fixedSize(horizontal: false, vertical: true)
                    .scrollContentBackground(.hidden)
                    .overlay {
                        if model.comment.isEmpty && !isFocused {
                            Label("Share an experience", systemImage: "bubble")
                                .fixedSize(horizontal: false, vertical: true)
                                .foregroundStyle(Color.gray.opacity(0.5))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 5)
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
    }
    
    func addComment() {
        Task {
            let commentId = try await model.addComment(locationId: locationId, currentUser: global.user)
            isFocused = false
            
            if let id = commentId {
                withAnimation {
                    scrollProxy.scrollTo(id)
                }
            }
        }
    }
}

#Preview {
    ScrollViewReader { proxy in
        CommentSection(locationId: UUID().uuidString, scrollProxy: proxy)
            .environment(GlobalModel(user: .example, defaultCords: Location.example.coordinates))
    }
}
