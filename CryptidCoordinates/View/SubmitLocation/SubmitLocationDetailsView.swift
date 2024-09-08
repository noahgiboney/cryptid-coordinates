//
//  SubmitLocationDetailsView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/16/24.
//

import SwiftUI

struct SubmitLocationDetailsView: View {
    
    @Binding var showCover: Bool
    @Environment(\.dismiss) var dismiss
    @FocusState private var descriptionFocused: Bool
    @State private var submitModel = SubmitLocationModel()
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Text("If you know of a spooky spot that is not on our map, let us know!")
                        .listRowSeparator(.hidden)
                    
                    Text("We will just need a few quick peices of information about the location.")
                }
                
                Section {
                    TextField("Location Name", text: Bindable(submitModel).locationName)
                }
                
                Section {
                    Text("Provide an overview of the history. Include chilling tales, errie history, and haunted lore.")
                    TextField("Description", text: Bindable(submitModel).description, axis: .vertical)
                }
                
                NavigationLink("Next") {
                    PickCordView(showCover: $showCover)
                }
                .disabled(submitModel.locationName.isEmpty || submitModel.description.isEmpty)
            }
            .navigationTitle("Submit Location")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar(.hidden, for: .tabBar)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
        .environment(submitModel)
    }
}

#Preview {
    SubmitLocationDetailsView(showCover: .constant(true))
}
