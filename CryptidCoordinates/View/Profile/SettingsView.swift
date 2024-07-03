//
//  SettingsView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/30/24.
//

import SwiftUI

struct SettingsView: View {
    @Environment(UserModel.self) var userModel
    @State private var isShowingSignOutAlert = false
    @State private var isShowingDeleteAccAlert = false
    @State private var isShowingDeleteAccDialog = false
    
    var body: some View {
        Form {
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
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Sign Out", isPresented: $isShowingSignOutAlert) {
            Button("Sign Out", role: .destructive) {
                try? userModel.signOut()
            }
        } message: {
            Text("Are you sure you want to sign out? You will have to sign back in next visit.")
        }
        .alert("Confirm Deletion", isPresented: $isShowingDeleteAccAlert) {
            Button("Delete", role: .destructive) {
                Task { try await userModel.deleteAccount() }
            }
        } message: {
            Text("Please confirm that you want to delete your account. Your data will be permanently lost.")
        }
        .confirmationDialog("Are you sure you want to delete your account? All your data will be lost.", isPresented: $isShowingDeleteAccDialog, titleVisibility: .visible, actions: {
            Button("Cancel", role: .cancel) {
                isShowingDeleteAccDialog.toggle()
            }
            
            Button("Sign Out Only") {
                try? userModel.signOut()
            }
            
            Button("Delete Account", role: .destructive) {
                isShowingDeleteAccAlert.toggle()
            }
        })
    }
}

#Preview {
    SettingsView()
        .environment(UserModel())
}
