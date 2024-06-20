//
//  HomeView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/14/24.
//

import Firebase
import SwiftUI

struct HomeView: View {
    @Environment(UserViewModel.self) var userViewModel
    @State private var viewModel = ViewModel()
    @State private var isShowingSubmitLocationSheet = false
    
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
                
                
                
                requestLocation
                    
            }
            .padding(.horizontal)
            .navigationTitle("Home")
            .sheet(isPresented: $isShowingSubmitLocationSheet) {
                SubmitLocationDetailsView()
            }
        }
    }
}

#Preview {
    HomeView()
        .environment(UserViewModel())
}

extension HomeView {
    private var requestLocation: some View {
        VStack(spacing: 10) {
            Text("Know of a spooky spot that is not on our map? Submit a location to have it featured.")
            Button("Submit a location") {
                isShowingSubmitLocationSheet.toggle()
            }
        }
        .font(.footnote)
    }
}
