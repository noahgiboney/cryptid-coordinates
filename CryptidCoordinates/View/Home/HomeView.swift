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
    @State private var requestModel = RequestModel()
    @State private var viewModel = ViewModel()
    
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
                
                NavigationLink("Reqest") {
                    RequestDetailView()
                }
            }
            .navigationTitle("Cryptid Coordinates")
        }
        .environment(requestModel)
    }
}

#Preview {
    HomeView()
        .environment(UserModel())
}
