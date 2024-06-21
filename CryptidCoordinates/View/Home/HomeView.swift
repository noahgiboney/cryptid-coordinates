//
//  HomeView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/14/24.
//

import Firebase
import SwiftUI

enum MenuSelection{
    case trending, nearYou, topRated
}

struct HomeView: View {
    @Environment(UserViewModel.self) var userViewModel
    @Environment(\.colorScheme) var colorScheme
    @Namespace private var menuNamespace
    @State private var viewModel = ViewModel()
    @State private var isShowingSubmitLocationSheet = false
    @State private var menuSelection: MenuSelection = .trending
    
    var body: some View {
        NavigationStack {
            ScrollView {
                
                switch menuSelection {
                case .trending:
                    Text("trending")
                case .nearYou:
                    Text("Near You")
                case .topRated:
                    Text("Top")
                }
                
//                LazyVStack(spacing: 60){
//                    ForEach(OldLocation.exampleArray) { location in
//                        LocationPreviewView(location: location)
//                    }
//                }
//                .padding(.top)
                
                requestLocation
                
            }
            .navigationTitle("Trending")
            .sheet(isPresented: $isShowingSubmitLocationSheet) {
                SubmitLocationDetailsView()
            }
            .overlay(alignment: .bottom) {
                menu
                    
            }
        }
    }
}

#Preview {
    HomeView()
        .environment(UserViewModel())
}

extension HomeView {
    private var menu: some View {
        HStack(spacing: 10){
            menuButton(text: "Trending", isSelected: menuSelection == .trending) {
                
                withAnimation {
                    menuSelection = .trending
                }
                
            }
            
            menuButton(text: "Near You", isSelected: menuSelection == .nearYou) {
                
                withAnimation {
                    menuSelection = .nearYou
                }
                
            }
            
            menuButton(text: "Top", isSelected: menuSelection == .topRated) {
                
                withAnimation {
                    menuSelection = .topRated
                }
                
            }
        }
        
        .background(Capsule()
            .fill(.ultraThickMaterial)
                    // .fill(colorScheme == .dark ? .gray.opacity(0.9) : .gray.opacity(0.8))
            .frame(width: 290, height: 45))
        .padding(.bottom)
    }
    
    private func menuButton(text: String, isSelected: Bool, action: @escaping () -> Void) -> some View{
        Button(action: action, label: {
            if isSelected {
                Text(text)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 3)
                    .background(
                        Capsule().fill(.gray.opacity(0.6)).matchedGeometryEffect(id: "menu", in: menuNamespace))
            } else {
                Text(text)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 3)
            }
        })
        .font(.headline)
        .buttonStyle(.plain)
        .foregroundStyle(isSelected ? .white : .gray)
    }
    
    
    private var requestLocation: some View {
        VStack(spacing: 55) {
            Text("Know of a spooky spot that is not on our map? Submit a location to have it featured.")
            Button("Submit a location") {
                isShowingSubmitLocationSheet.toggle()
            }
        }
        .padding(.horizontal)
        .font(.footnote)
    }
}
