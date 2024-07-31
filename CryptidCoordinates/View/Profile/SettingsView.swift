//
//  SettingsView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/30/24.
//

import SwiftUI

struct SettingsView: View {
    @Environment(AuthModel.self) var authModel
    @State private var isShowingSignOutAlert = false
    @State private var isShowingDeleteAccAlert = false
    @State private var isShowingDeleteAccDialog = false
    
    var body: some View {
        Form {
            Section {
                Button("Manage Location Settings", systemImage: "location") {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }
            }
            
            Section {
                Button {
                    isShowingSignOutAlert.toggle()
                } label: {
                    Label("Sign Out", systemImage: "rectangle.portrait.and.arrow.right")
                }
                
                Button(role: .destructive) {
                    isShowingDeleteAccDialog.toggle()
                } label: {
                    Label("Delete Account", systemImage: "trash")
                }
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .alert("Sign Out", isPresented: $isShowingSignOutAlert) {
            Button("Sign Out", role: .destructive) {
                try? authModel.signOut()
            }
        } message: {
            Text("Are you sure you want to sign out? You will have to sign back in next visit.")
        }
        .alert("Confirm Deletion", isPresented: $isShowingDeleteAccAlert) {
            Button("Delete", role: .destructive) {
                Task { try await authModel.deleteAccount() }
            }
        } message: {
            Text("Please confirm that you want to delete your account. Your data will be permanently lost.")
        }
        .confirmationDialog("Are you sure you want to delete your account? All your data will be lost.", isPresented: $isShowingDeleteAccDialog, titleVisibility: .visible, actions: {
            Button("Cancel", role: .cancel) {
                isShowingDeleteAccDialog.toggle()
            }
            
            Button("Sign Out Only") {
                try? authModel.signOut()
            }
            
            Button("Delete Account", role: .destructive) {
                isShowingDeleteAccAlert.toggle()
            }
        })
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButton()
            }
        }
    }
}

#Preview {
    SettingsView()
        .environment(AuthModel())
}
