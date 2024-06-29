//
//  CommentSection.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/22/24.
//

import SwiftUI

struct CommentSection: View {
    @FocusState private var isFocused: Bool
    @State private var comment = ""
    let location: Location
    
    var body: some View {
        VStack(spacing: 30){
            HStack {
                Text("156 comments")
                    .font(.headline)
                    
                Spacer()
                
                Button {
                    
                } label: {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .imageScale(.large)
                }
            }
            
            HStack {
                TextField("Share Your Experince", text: $comment)
                    .padding(.leading, 5)
                    .padding(2)
                
                if !comment.isEmpty {
                    Button {
                        
                    } label: {
                        Image(systemName: "arrow.up.circle.fill")
                            .imageScale(.large)
                    }
                }
            }
            .padding(4)
            .background(
                Capsule().stroke(Color.gray.opacity(0.5), lineWidth: 1.0)
            )
            
            LazyVStack(alignment: .leading, spacing: 25) {
                ForEach(0..<10) { _ in
                    CommentView(comment: Comment.example)
                }
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    CommentSection(location: Location.example)
}
