//
//  SavedView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 7/11/24.
//

import Kingfisher
import SwiftUI

struct SavedView: View {
    @Environment(LocationStore.self) var store
    @State private var searchText = ""
    @State private var loadState = LoadState.loading
    
    var filteredList: [Location] {
        if searchText.isEmpty {
            return store.savedLocations
        } else {
            return store.savedLocations.filter { $0.name.localizedStandardContains(searchText) }
        }
    }
    
    var body: some View {
        Group {
            switch loadState {
            case .loading:
                ProgressView()
            case .loaded:
                listView
            case .error:
                ProgressView()
            }
        }
        .navigationTitle("Saved")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .searchable(text: $searchText)
        .toolbar {
            if !store.savedLocations.isEmpty {
                ToolbarItem(placement: .topBarTrailing){
                    EditButton()
                }
            }
            
            ToolbarItem(placement: .topBarLeading){
                BackButton()
            }
        }
        .task {
            do {
                try await store.fetchSaved()
                loadState = .loaded
            } catch {
                loadState = .error
            }
        }
    }
    
    @ViewBuilder
    var listView: some View {
        if !filteredList.isEmpty {
            List {
                ForEach(store.savedLocations) { location in
                    NavigationLink {
                        LocationView(location: location)
                    } label: {
                        VStack(alignment: .leading) {
                            Text(location.name)
                            Text(location.cityState)
                                .font(.footnote)
                                .foregroundStyle(.gray)
                        }
                    }
                }
            }
        } else if store.savedLocations.isEmpty {
            ContentUnavailableView("Nothing saved yet", systemImage: "house.lodge")
        } else {
            ContentUnavailableView.search
        }
    }
}

#Preview {
    NavigationStack {
        SavedView()
            .environment(LocationStore())
    }
}
