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
                LazyVStack {
                    LocationPreviewView(location: Location.example)
                    
                    LocationPreviewView(location: Location.example)
                    
                    LocationPreviewView(location: Location.example)
                    
                    LocationPreviewView(location: Location.example)
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
