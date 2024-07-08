//
//  EditProfileView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/29/24.
//

import SwiftUI

struct EditProfileView: View {
    @Environment(ViewModel.self) var viewModel
    @Environment(\.dismiss) var dismiss
    @Binding var user: User
    @State private var tempUser: User
    @State private var selectedPfp: ProfilePicture
    @State private var scrollPosition: ProfilePicture?
    @Namespace var nsPfp
    
    init(user: Binding<User>) {
        self._user = user
        self._tempUser = State(initialValue: user.wrappedValue)
        self._selectedPfp = State(initialValue: user.profilePicture.wrappedValue)
    }
    
    var body: some View {
        Form {
            Section("Display Name") {
                    TextField(tempUser.name, text: $tempUser.name)
            }
            
            Section("Avatar") {
                pfpScrollView
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
                    Button("Save") {
                        Task {
                            user = tempUser
                            try await viewModel.updateUser(updatedUser: user)
                            dismiss()
                        }
                    }
                }
            }
        }
    }
    
    var pfpScrollView: some View {
        ScrollViewReader { scrollView in
            ScrollView(.horizontal, showsIndicators: false){
                HStack(spacing: 20){
                    ForEach(ProfilePicture.allCases, id: \.self) { pfp in
                        ProfilePictureRowItem(isSelected: selectedPfp == pfp, profilePicture: pfp, nsPfp: nsPfp)
                            .id(pfp)
                            .onTapGesture{
                                withAnimation(.snappy){
                                    selectedPfp = pfp
                                }
                            }
                    }
                }
                .padding(.vertical, 50)
            }
            .listRowInsets(.init())
            .onChange(of: selectedPfp) { oldValue, newValue in
                withAnimation {
                    scrollView.scrollTo(selectedPfp, anchor: .center)
                }
            }
        }
    }
}

struct ProfilePictureRowItem: View {
    var isSelected: Bool
    var profilePicture: ProfilePicture
    @Environment(\.colorScheme) var scheme
    var nsPfp: Namespace.ID
    
    var body: some View {
            profilePicture.image
                .resizable()
                .scaledToFit()
                .foregroundStyle(.black)
                .frame(width: 90, height: 90)
                .scaleEffect(isSelected ? 1.1 : 1)
                .overlay(alignment: .top) {
                    if isSelected {
                        Image(systemName: "triangle.fill")
                            .rotationEffect(.degrees(180))
                            .matchedGeometryEffect(id: "PFP", in: nsPfp)
                            .offset(y: -40)
                    }
                }
    }
}

#Preview {
    NavigationStack {
        EditProfileView(user: .constant(.example))
            .environment(ViewModel(user: .example))
    }
}
