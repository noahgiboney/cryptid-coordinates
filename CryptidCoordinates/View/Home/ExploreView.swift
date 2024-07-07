//
//  TrendingView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/23/24.
//

import SwiftUI

struct ExploreView: View {
    @State private var page = 0
    
    var body: some View {
        NavigationStack {
            VStack {                
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
            }
        }
    }
}

#Preview {
    ExploreView()
}
