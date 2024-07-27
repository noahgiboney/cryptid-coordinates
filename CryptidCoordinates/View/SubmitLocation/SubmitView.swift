//
//  RequestSubmitView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/16/24.
//

import SwiftUI

struct SubmitView: View {
    @Binding var showCover: Bool
    @Environment(\.dismiss) var dismiss
    @Environment(SubmitLocationModel.self) var submitModel
    
    var body: some View {
        Form {
            Section {
                Text("Take a moment to review the information to ensure it is correct. When are you done submit below.")
            }
            
            Section {
                Text("Name: \(submitModel.locationName)")
                
                Text("Description: \(submitModel.description)")
                
                if let cords = submitModel.coordinates {
                    Text("Coordinates: (\(cords.latitude), \(cords.longitude))")
                }
            }
            
            Button {
                Task { try await submitModel.sumbitRequest() }
            } label: {
                HStack {
                    Text("Submit")
                    Image(systemName: "paperplane")
                }
            }
        }
        .navigationTitle("Review")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Request Sent", isPresented: Bindable(submitModel).isShowingAlert) {
            Button("Ok") {
                showCover = false
            }
            
        } message: {
            Text(submitModel.alertMessage)
        }
    }
}

#Preview {
    NavigationStack{
        SubmitView(showCover: .constant(true))
            .environment(SubmitLocationModel())
    }
}
