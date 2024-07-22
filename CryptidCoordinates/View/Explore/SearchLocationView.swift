//
//  SearchListView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 7/22/24.
//

import SwiftData
import SwiftUI

struct SearchListView: View {
    var searchText: String
    @Query
    
    init(searchText: String) {
        self.searchText = searchText
    }
    
    var body: some View {
        ForEach
    }
}

#Preview {
    SearchListView()
}
