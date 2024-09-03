//
//  EditProfileView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/29/24.
//

import SwiftUI

struct EditProfileView: View {
    @Binding var user: User
    @Environment(GlobalModel.self) var global
    @Environment(\.dismiss) var dismiss
    @State private var tempUser: User
    @State private var selectedAvatar: Avatar
    @State private var scrollPosition: Avatar?
    @Namespace var nsPfp
    
    init(user: Binding<User>) {
        self._user = user
        self._tempUser = State(initialValue: user.wrappedValue)
        self._selectedAvatar = State(initialValue: user.avatar.wrappedValue)
    }
    
    private func updateUser() {
        Task {
            user = tempUser
            
            do {
                try await FirebaseService.shared.updateData(object: tempUser, ref: Collections.users)
            } catch {
                print("Error: updateUser(): \(error.localizedDescription)")
            }
        }
        dismiss()
    }
    
    private let columns = [GridItem(), GridItem(), GridItem()]
    
    var body: some View {
        Form {
            Section("Name") {
                TextField(tempUser.name, text: $tempUser.name)
            }
            
            Section("Avatar") {
                avatarGrid
            }
        }
        .navigationTitle("Edit Profile")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButton()
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save", action: updateUser)
                    .disabled(tempUser == user || tempUser.name.isEmpty)
            }
        }
        .onChange(of: selectedAvatar) { _, _ in
            tempUser.avatar = selectedAvatar
        }
    }
    
    
    
    var avatarGrid: some View {
        LazyVGrid(columns: columns, spacing: 85) {
            ForEach(Avatar.allCases, id: \.self) { avatar in
                VStack {
                    AvatarRowView(isSelected: selectedAvatar == avatar, avatar: avatar, nsPfp: nsPfp)
                        .id(avatar)
                        .onTapGesture{
                            withAnimation(.snappy){
                                selectedAvatar = avatar
                            }
                        }
                }
            }
        }
        .padding(.vertical, 50)
        .padding(.bottom)
        .listRowInsets(.init())
    }
}

#Preview {
    NavigationStack {
        EditProfileView(user: .constant(.example))
            .environment(GlobalModel(user: .example, defaultCords: Location.example.coordinates))
            .preferredColorScheme(.dark)
        
    }
}
