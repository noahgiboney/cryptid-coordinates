//
//  SettingsView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/30/24.
//

import SwiftUI

struct SettingsScreen: View {
    
    @Environment(AuthModel.self) var authModel
    @Environment(Saved.self) var saved
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
                .foregroundStyle(.blue)
            }
            
            Section {
                NavigationLink {
                    FeedbackScreen()
                } label: {
                    Label("Feedback", systemImage: "bubble.left.and.bubble.right")
                }
                .foregroundStyle(.blue)
            }
            
            Section {
                Button {
                    isShowingSignOutAlert.toggle()
                } label: {
                    Label("Sign Out", systemImage: "rectangle.portrait.and.arrow.right")
                }
                .foregroundStyle(.blue)
                
                Button(role: .destructive) {
                    isShowingDeleteAccDialog.toggle()
                } label: {
                    Label("Delete Account", systemImage: "trash")
                }
                .foregroundStyle(.red)
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .alert("Sign Out", isPresented: $isShowingSignOutAlert) {
            Button("Sign Out", role: .destructive) {
                authModel.signOut()
            }
        } message: {
            Text("Are you sure you want to sign out? You will have to sign back in next visit.")
        }
        .alert("Confirm Deletion", isPresented: $isShowingDeleteAccAlert) {
            Button("Delete", role: .destructive) {
                Task { 
                    await authModel.deleteAccount()
                    saved.wipeSaved()
                }
            }
        } message: {
            Text("Please confirm that you want to delete your account. Your data will be permanently lost.")
        }
        .confirmationDialog("Are you sure you want to delete your account? All your data will be lost.", isPresented: $isShowingDeleteAccDialog, titleVisibility: .visible, actions: {
            Button("Cancel", role: .cancel) {
                isShowingDeleteAccDialog.toggle()
            }
            
            Button("Sign Out Only") {
                authModel.signOut()
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
    SettingsScreen()
        .environment(Saved())
        .environment(AuthModel())
}
