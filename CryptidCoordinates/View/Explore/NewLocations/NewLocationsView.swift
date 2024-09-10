//
//  NewLocationsView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 9/6/24.
//

import Firebase
import SwiftData
import SwiftUI

struct NewLocationsView: View {
    
    @Environment(LocationStore.self) var locations
    @State private var showSubmitRequest = false
    @State private var didAppear = false
    
    var body: some View {
        ExploreTabContainer(title: "New", description: "Locations added by users") {
            VStack(spacing: 15) {
                Button("Submit Location", systemImage: "square.and.pencil") {
                    showSubmitRequest.toggle()
                }
                .buttonStyle(.borderless)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 20)
                
                Divider()
            }
            .padding(.top)
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets())
            .fullScreenCover(isPresented: $showSubmitRequest) {
                SubmitLocationDetailsView(showCover: $showSubmitRequest)
            }
            
            ScrollView {
                LazyVStack(spacing: 35) {
                    ForEach(locations.new) { location in
                        if let user = location.user {
                            NewLocationCellView(newLocation: location, user: user)
                        }
                    }
                    .listRowInsets(EdgeInsets())
                }
            }
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets())
            .padding(.vertical, 30)
        }
        .task {
            guard !didAppear else { return }
            await locations.fetchNewLocations()
            didAppear = true
        }
    }
}

#Preview {
    List {
        NewLocationsView()
            .environment(LocationStore())
    }
    .listStyle(.plain)
}
