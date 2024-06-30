//
//  ProfileView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/15/24.
//

import SwiftUI

struct ProfileView: View {
    @Environment(UserViewModel.self) var userModel
    @State private var isShowingSignOutAlert = false
    @State private var isShowingDeleteAccAlert = false
    @State private var isShowingDeleteAccDialog = false
    
    var body: some View {
        Group {
            if true {
                NavigationStack {
                    VStack(alignment: .trailing) {
                        ProfilePictureView(type: .profile)
                    }
                    .navigationTitle("Noah Giboney")
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button {
                                
                            } label: {
                                Image(systemName: "pencil")
                            }
                        }
                        
                        ToolbarItem(placement: .topBarTrailing) {
                            Menu {
                                Button {
                                    isShowingSignOutAlert.toggle()
                                } label: {
                                    Label("Sign Out", systemImage: "door.left.hand.open")
                                }
                                
                                Button(role: .destructive) {
                                    isShowingDeleteAccDialog.toggle()
                                } label: {
                                    Label("Delete Account", systemImage: "trash")
                                }
                            } label: {
                                Image(systemName: "gearshape")
                            }
                        }
                    }
                    .alert("Confirm Sign Out", isPresented: $isShowingSignOutAlert) {
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
        }
    }
}

#Preview {
    ProfileView()
        .environment(UserViewModel())
}
