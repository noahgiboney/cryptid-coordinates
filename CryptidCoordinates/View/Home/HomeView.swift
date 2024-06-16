//
//  HomeView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/14/24.
//

import Firebase
import SwiftUI

struct HomeView: View {
    @Environment(UserModel.self) var userModel
    @State private var viewModel = ViewModel(client: LocationService())
    
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
                            ForEach(OldLocation.exampleArray) { location in
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
        .environment(UserModel())
}
