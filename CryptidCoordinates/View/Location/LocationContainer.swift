//
//  LocationContainer.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 9/7/24.
//

import SwiftUI

struct LocationContainer: View {
    
    let location: Location
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        LocationScreen(location: location)
            .navigationBarBackButtonHidden()
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .padding(10)
                            .background(.ultraThinMaterial, in: Circle())
                            .padding()
                    }
                }
            }
    }
}

#Preview {
    LocationContainer(location: .example)
}
