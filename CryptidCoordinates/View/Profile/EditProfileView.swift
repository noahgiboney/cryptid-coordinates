//
//  EditProfileView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/29/24.
//

import SwiftUI

struct EditProfileView: View {
    @State private var displayName = ""
    @State private var selectedPfp: ProfilePicture = .killer
    @Namespace var nsPfp
    
    var body: some View {
        Form {
            Section{
                TextField(displayName, text: $displayName)
                
                pfpScrollView
            }
            
            Section {
                Button("Save") {
                    
                }
            }
        }
        .navigationTitle("Edit Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    var pfpScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false){
            HStack(spacing: 20){
                ForEach(ProfilePicture.allCases, id: \.self) { pfp in
                    ProfilePictureRowItem(isSelected: selectedPfp == pfp, profilePicture: pfp, nsPfp: nsPfp)
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
    }
}

struct ProfilePictureRowItem: View {
    var isSelected: Bool
    var profilePicture: ProfilePicture
    @Environment(\.colorScheme) var scheme
    var nsPfp: Namespace.ID
    
    
    var glowColor: Color {
        if scheme == .dark{
            return .white
        } else {
            return .black
        }
    }
    
    var body: some View {
            profilePicture.image
                .resizable()
                .scaledToFit()
                .foregroundStyle(scheme == .dark ? .white : .black)
                .frame(width: 90, height: 90)
                .scaleEffect(isSelected ? 1.1 : 1)
                .shadow(color: !isSelected ? glowColor.opacity(0.5) : Color.clear, radius: 20, x: 0, y: 0)
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
        EditProfileView()
    }
}
