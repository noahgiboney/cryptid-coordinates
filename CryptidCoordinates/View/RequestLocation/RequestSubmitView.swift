//
//  RequestSubmitView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/16/24.
//

import SwiftUI

struct RequestSubmitView: View {
    @Environment(RequestModel.self) var requestModel
    
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
                    Image(systemName: "arrow.up")
                }
            }
        }
        .navigationTitle("Review")
    }
}

#Preview {
    NavigationStack{
        RequestSubmitView()
            .environment(RequestModel())
    }
}
