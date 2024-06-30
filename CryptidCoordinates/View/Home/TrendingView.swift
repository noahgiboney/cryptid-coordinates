//
//  TrendingView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/23/24.
//

import SwiftUI

struct TrendingView: View {
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 30){
                    LocationPreviewView(location: Location.example)
                    
                    LocationPreviewView(location: Location.example)
                    
                    LocationPreviewView(location: Location.example)
                    
                    LocationPreviewView(location: Location.example)
                    
//                    Button("Load More", systemImage: "ellipsis") {
//                        //
//                    }
                }
                .padding(.top)
            }
            .navigationTitle("Trending")
        }
    }
}

#Preview {
    TrendingView()
}
