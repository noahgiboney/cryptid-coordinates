//
//  HomeView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/14/24.
//

import SwiftUI

struct HomeView: View {
    @Environment(ViewModel.self) var viewModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack{
                    Text("Trending")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    ScrollView(.horizontal) {
                        LazyHStack{
                            ForEach(Location.exampleArray) { location in
                                TopRatedView(location: location)
                            }
                        }
                    }
                }
                .padding(.leading)
            }
            .navigationTitle("Cryptid Coordinates")
        }
    }
}

#Preview {
    HomeView()
        .environment(ViewModel(client: FirestoreClient()))
}
