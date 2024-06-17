//
//  RequestSubmitView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/16/24.
//

import SwiftUI

struct SubmitView: View {
    @Environment(SubmitLocationViewModel.self) var requestModel
    
    var body: some View {
        Form {
            Section {
                Text("Name: ")
                    .font(.headline) +
                Text(requestModel.locationName)
                
                Text("Description: ")
                    .font(.headline) +
                Text(requestModel.description)
                
                if let cords = requestModel.coordinates {
                    Text("Coordinates: ")
                        .font(.headline)
                    
                    Text("x: \(cords.latitude)")
                        .listRowSeparator(.hidden)
                    
                    Text("y: \(cords.longitude)")
                        .listRowSeparator(.hidden)
                }
            }
            
            Button {
                // submit for review
            } label: {
                HStack {
                    Text("Submit")
                    Image(systemName: "paperplane")
                }
            }
        }
        .navigationTitle("Review")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarRole(.editor)
    }
}

#Preview {
    NavigationStack{
        SubmitView()
            .environment(SubmitLocationViewModel())
    }
}
