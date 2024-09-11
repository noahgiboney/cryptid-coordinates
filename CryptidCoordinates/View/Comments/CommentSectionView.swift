//
//  CommentSectionView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/22/24.
//

import Firebase
import SwiftUI

struct CommentSectionView: View {
    
    let locationId: String
    let scrollProxy: ScrollViewProxy
    @Environment(Global.self) var global
    @FocusState private var isFocused: Bool
    @State private var model = CommentSection()
    
    private func addComment() {
        Task {
            let commentId = await model.addNewComment(for: locationId, currentUser: global.user)
            isFocused = false
            
            if let id = commentId {
                withAnimation {
                    scrollProxy.scrollTo(id)
                }
            }
        }
    }
    
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
        .onChange(of: model.comments) { oldValue, newValue in
            if !model.comments.isEmpty {
                model.loadState = .loaded
            } else if model.comment.isEmpty {
                model.loadState = .empty
            }
        }
        .task {
            await model.fetchComments(locationId)
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
        LazyVStack(alignment: .leading, spacing: 35) {
            ForEach(model.comments) { comment in
                CommentView(comment: comment, model: model)
                    .id(comment.id)
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
}

#Preview {
    ScrollViewReader { proxy in
        CommentSectionView(locationId: UUID().uuidString, scrollProxy: proxy)
            .environment(Global(user: .example, defaultCords: Location.example.coordinates))
    }
}

