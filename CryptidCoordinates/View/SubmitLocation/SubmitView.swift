//
//  RequestSubmitView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/16/24.
//

import SwiftUI

struct SubmitView: View {
    @Environment(SubmitLocationModel.self) var requestModel
    
    var body: some View {
        Form {
            Section {
                Text("Take a moment to review the information to ensure it is correct. When are you done submit below.")
                
                Text("Name: \(requestModel.locationName)")
                
                Text("Description: \(requestModel.description)")
                
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
                Task { try await requestModel.sumbitRequest() }
            } label: {
                HStack {
                    Text("Submit")
                    Image(systemName: "paperplane")
                }
            }
            .buttonStyle(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=Button Style@*/DefaultButtonStyle()/*@END_MENU_TOKEN@*/)
        }
        .navigationTitle("Review")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarRole(.editor)
        .alert("Done", isPresented: Bindable(requestModel).isShowingAlert) {
            Button("Ok") {
                // dismiss
            }

        } message: {
            Text(requestModel.alertMessage)
        }
    }
}

#Preview {
    NavigationStack{
        SubmitView()
            .environment(SubmitLocationModel())
    }
}
