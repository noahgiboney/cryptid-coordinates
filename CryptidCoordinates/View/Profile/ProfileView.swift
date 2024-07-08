//
//  ProfileView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/15/24.
//

import SwiftUI

struct ProfileView: View {
    @Environment(ViewModel.self) var viewModel
    @Environment(AuthModel.self) var authModel
    @Environment(\.colorScheme) var colorScheme
    @State private var isShowingSignOutAlert = false
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    ProfilePictureView(type: .profile, user: .example)
                        .listRowBackground(Color.clear)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical)
                }
                .listRowSeparator(.hidden)
                
                NavigationLink {
                    EditProfileView(user: Bindable(viewModel).user)
                } label: {
                    Label("Edit Profile", systemImage: "pencil")
                }
                
                NavigationLink {
                    SettingsView()
                } label: {
                    Label("Settings", systemImage: "gearshape")
                }
                
                NavigationLink {
                    //
                } label: {
                    Label("Favorites", systemImage: "heart.fill")
                }
                
                NavigationLink {
                    //
                } label: {
                    Label("Comments", systemImage: "message")
                }
                
                NavigationLink {
                    SubmitLocationDetailsView()
                } label: {
                    Label("Submit Location", systemImage: "map")
                }
            }
            .listStyle(InsetListStyle())
            .navigationTitle(viewModel.user.name)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isShowingSignOutAlert.toggle()
                    } label: {
                        Label("Sign Out", systemImage: "rectangle.portrait.and.arrow.right")
                    }
                }
            }
            .alert("Sign Out", isPresented: $isShowingSignOutAlert) {
                Button("Sign Out", role: .destructive) {
                    try? authModel.signOut()
                }
            } message: {
                Text("Are you sure you want to sign out? You will have to sign back in next visit.")
            }
        }
    }
    
    private var requestLocation: some View {
        VStack(spacing: 10) {

        }
        .padding(.horizontal)
        .font(.footnote)
    }
}

#Preview {
    ProfileView()
        .environment(AuthModel())
        .environment(ViewModel(user: .example))
}
