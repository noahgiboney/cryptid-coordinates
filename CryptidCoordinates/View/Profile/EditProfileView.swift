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
                if tempUser != user {
                    Button("Save", action: updateUser)
                }
            }
        }
        .onChange(of: selectedAvatar) { _, _ in
            tempUser.avatar = selectedAvatar
        }
    }
    
    func updateUser() {
        user = tempUser
        Task {
            do {
                try await UserService.shared.updateWholeUser(updateUser: tempUser)
            } catch {
                print("Error: updateUser(): \(error.localizedDescription)")
            }
        }
        dismiss()
    }
    
    var avatarGrid: some View {
        LazyVGrid(columns: columns, spacing: 85) {
            ForEach(Avatar.allCases, id: \.self) { avatar in
                let isLocked = user.visits < avatar.cost
                VStack {
                    AvatarRowItem(isSelected: selectedAvatar == avatar, isLocked: isLocked, avatar: avatar, nsPfp: nsPfp)
                        .id(avatar)
                        .onTapGesture{
                            if !isLocked {
                                withAnimation(.snappy){
                                    selectedAvatar = avatar
                                }
                            }
                        }
                        .overlay(alignment: .bottom) {
                            if isLocked {
                                VStack {
                                    HStack(spacing: 3){
                                        Image(systemName: "lock.fill")
                                        Text("Locked")
                                    }
                                    Text("\(avatar.cost) Visits")
                                }
                                .font(.footnote)
                                .foregroundStyle(.gray)
                                .offset(y: 45)
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

struct AvatarRowItem: View {
    var isSelected: Bool
    var isLocked: Bool
    var avatar: Avatar
    var nsPfp: Namespace.ID
    @Environment(\.colorScheme) var scheme
    
    var body: some View {
        avatar.image
            .resizable()
            .scaledToFit()
            .foregroundStyle(.black)
            .frame(width: 90, height: 90)
            .scaleEffect(isSelected && !isLocked ? 1.1 : 1)
            .overlay(alignment: .top) {
                if isSelected {
                    Image(systemName: "triangle.fill")
                        .rotationEffect(.degrees(180))
                        .matchedGeometryEffect(id: "PFP", in: nsPfp)
                        .offset(y: -30)
                }
            }
            .lockedModifier(isLocked: isLocked)
    }
}

#Preview {
    NavigationStack {
        EditProfileView(user: .constant(.example))
            .environment(GlobalModel(user: .example))

    }
}

struct LockedViewModifier: ViewModifier  {
    var isLocked: Bool
    
    func body(content: Content) -> some View {
        content
            .shadow(color: Color.black.opacity(0.6), radius: isLocked ? 8 : 0, x: 0, y: 0)
    }
}

extension View {
    func lockedModifier(isLocked: Bool) -> some View {
        self.modifier(LockedViewModifier(isLocked: isLocked))
    }
}
