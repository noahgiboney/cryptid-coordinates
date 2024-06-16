//
//  RequestLocationView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/16/24.
//

import SwiftUI

struct RequestDetailView: View {
    @Environment(RequestModel.self) var requestModel
    @FocusState private var textEditorFocused: Bool
    
    var body: some View {
        Form {
            Section("Details") {
                TextField("Location Name", text: Bindable(requestModel).locationName)
                
                TextEditor(text: Bindable(requestModel).description)
                    .overlay {
                        if requestModel.description == "" && !textEditorFocused {
                            Text("Location Description")
                                .foregroundStyle(Color.gray.opacity(0.5))
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .onTapGesture {
                        textEditorFocused = true
                    }
                    .focused($textEditorFocused)
                    .onReceive(requestModel.description.publisher.last()) {
                        if ($0 as Character).asciiValue == 10 {
                            textEditorFocused = false
                            requestModel.description.removeLast()
                        }
                    }
            }
            
            NavigationLink("Choose Location Coordinates") {
                RequestMapView()
            }
            .foregroundStyle(.blue)
            .disabled(requestModel.locationName.isEmpty || requestModel.description.isEmpty)
        }
        .navigationTitle("Request a Location")
    }
}

#Preview {
    RequestDetailView()
        .environment(RequestModel())
}
