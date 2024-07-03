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
    @Environment(\.colorScheme) var colorScheme
    @State private var isShowingSignOutAlert = false
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
    
    private var darkModeColors: [Color] {
        [Color("AccentColor"), Color.black]
    }
    
    private var lightModeColors: [Color] {
        [ Color("AccentColor"), Color.white]
    }
    @State var colors: [(id: Int, color: UIColor, frequency: CGFloat)] = []
    @State var gradietnModel = AnimatedGradient.Model(colors: [])
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    ProfilePictureView(type: .profile, user: .example)
                        .offset(x: offsetX, y: offsetY)
                        .gesture(drag)
                        .listRowBackground(Color.clear)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                
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
                    SubmitLocationDetailsView()
                } label: {
                    Label("Submit Location", systemImage: "map")
                }
            }
            .navigationTitle("Noah Giboney")
            .scrollContentBackground(.hidden)
            .background(GradientEffectView($gradietnModel)
                .ignoresSafeArea()
                .onAppear {
                    gradietnModel.colors = colorScheme == .dark ? darkModeColors : lightModeColors
                })
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
                    try? userModel.signOut()
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
        .environment(UserModel())
        .environment(ViewModel(user: .example))
}
