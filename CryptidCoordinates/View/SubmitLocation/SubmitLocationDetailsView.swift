//
//  RequestLocationView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/16/24.
//

import SwiftUI

struct SubmitLocationDetailsView: View {
    @FocusState private var textEditorFocused: Bool
    @State private var submitViewModel = SubmitLocationViewModel()
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Text("If you konw of a spooky spot that is not on our map, let us know!")
                        .listRowSeparator(.hidden)
                    
                    Text("We will just need a few quick peices of information about the location.")
                }
                
                Section {
                    TextField("What is the name of the location?", text: Bindable(submitViewModel).locationName)
                    
                    Group {
                        if submitViewModel.description.isEmpty {
                            TextEditor(text: Bindable(submitViewModel).description)
                                .frame(height: 65)
                        } else {
                            TextEditor(text: Bindable(submitViewModel).description)
                        }
                    }
                    .overlay {
                        if submitViewModel.description == "" && !textEditorFocused {
                            Text("Provide an overview of the history. Include chilling tales, errie history, and haunted lore.")
                                .fixedSize(horizontal: false, vertical: true)
                                .foregroundStyle(Color.gray.opacity(0.5))
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .onTapGesture {
                        textEditorFocused = true
                    }
                    .focused($textEditorFocused)
                    .onReceive(submitViewModel.description.publisher.last()) {
                        if ($0 as Character).asciiValue == 10 {
                            textEditorFocused = false
                            submitViewModel.description.removeLast()
                        }
                    }
                }
                
                NavigationLink {
                    PickCordView()
                } label: {
                    Label("Pick Coordinates", systemImage: "mappin.and.ellipse")
                }
                .disabled(submitViewModel.locationName.isEmpty || submitViewModel.description.isEmpty)
            }
            .navigationTitle("Submit Location")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    BackButton()
                }
            }
        }
        .environment(submitViewModel)
    }
}

#Preview {
    SubmitLocationDetailsView()
}
