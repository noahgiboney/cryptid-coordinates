//
//  ProfileView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/15/24.
//

import SwiftUI

struct ProfileView: View {
    @Environment(GlobalModel.self) var global
    @Environment(AuthModel.self) var authModel
    @Environment(\.colorScheme) var colorScheme
    @State private var isShowingSignOutAlert = false
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    AvatarView(type: .profile, user: .example)
                        .listRowBackground(Color.clear)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical)
                }
                .listRowSeparator(.hidden)
                
                NavigationLink {
                    EditProfileView(user: Bindable(global).user)
                } label: {
                    Label("Edit Profile", systemImage: "pencil")
                }
                
                NavigationLink {
                    SettingsView()
                } label: {
                    Label("Settings", systemImage: "gearshape")
                }
                
                NavigationLink {
                    SavedView()
                } label: {
                    Label("Saved", systemImage: "bookmark")
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
                
                VStack {
                    Text("157 Locations Visited")
                        .font(.title3.bold()) 
                }
                .padding(.top)
                .listRowSeparator(.hidden, edges: .bottom)
            }
            .listStyle(InsetListStyle())
            .navigationTitle(global.user.name)
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
        .environment(GlobalModel(user: .example))
}
