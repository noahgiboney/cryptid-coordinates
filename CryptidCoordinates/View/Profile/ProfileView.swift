//
//  ProfileView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/15/24.
//

import SwiftUI

struct ProfileView: View {
    @Environment(UserModel.self) var userModel
    @Environment(ViewModel.self) var viewModel
    @State private var isShowingSignOutAlert = false
    @State private var isShowingDeleteAccAlert = false
    @State private var isShowingDeleteAccDialog = false
    @State private var offsetX = 0.0
    @State private var offsetY = 0.0
    
    var drag: some Gesture {
        DragGesture()
            .onChanged { gesture in
                offsetX = gesture.translation.width
                offsetY = gesture.translation.height
            }
            .onEnded { _ in
                withAnimation(.bouncy(duration: 0.6)){
                    offsetX = 0.0
                    offsetY = 0.0
                }
            }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    ProfilePictureView(type: .profile, user: .example)
                        .offset(x: offsetX, y: offsetY)
                        .gesture(drag)
                    NavigationLink {
                        EditProfileView(user: Bindable(viewModel).user)
                    } label: {
                        Label("Edit Profile", systemImage: "pencil")
                    }
                }
            }
            .navigationTitle("Noah Giboney")
            .toolbar {
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

#Preview {
    ProfileView()
        .environment(UserModel())
        .environment(ViewModel(user: .example))
}
