//
//  ExploreView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/23/24.
//

import SwiftUI

struct ExploreView: View {
    @State private var exploreModel = ExploreModel()
    @Binding var isShowingMenu: Bool
    
    var body: some View {
        NavigationStack {
            Group{
                switch exploreModel.loadState {
                case .loading:
                    ProgressView()
                case .loaded:
                    listView
                case .error:
                    Text("Hel")
                }
            }
            .navigationTitle("Explore")
            .task {
                try? await exploreModel.populateLocations()
            }
        }
    }
    
    private var listView: some View {
        List {
            ForEach(exploreModel.locations) { location in
                LocationPreviewView(location: location)
                    .background {
                        NavigationLink("") {
                            LocationView(location: location)
                                .onAppear { isShowingMenu = false }
                                .onDisappear { isShowingMenu = true }
                        }
                        .opacity(0.0)
                    }
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets())
                    .task {
                        if location == exploreModel.locations.last {
                            try? await exploreModel.populateLocations()
                        }
                    }
            }
        }
        .listStyle(.plain)
        .listRowSpacing(30)
    }
    
    private var scrollView: some View {
        ScrollView {
            LazyVStack(spacing: 40){
                ForEach(exploreModel.locations) { location in
                    LocationPreviewView(location: location)
                        .background {
                            NavigationLink("") {
                                LocationView(location: location)
                                    .onAppear { isShowingMenu = false }
                                    .onDisappear { isShowingMenu = true }
                            }
                            .opacity(0.0)
                        }
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets())
                        .task {
                            if location == exploreModel.locations.last {
                                try? await exploreModel.populateLocations()
                            }
                        }
                }
            }
        }
    }
}

#Preview {
    ExploreView(isShowingMenu: .constant(false))
}
