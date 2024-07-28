//
//  ProfileView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/15/24.
//

import Collections
import Firebase
import SwiftData
import SwiftUI

struct ProfileView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(GlobalModel.self) var global
    @Environment(AuthModel.self) var authModel
    @Environment(\.colorScheme) var colorScheme
    @State private var showSubmitRequest = false
    @State private var isShowingSignOutAlert = false
    @State private var visitedLocations: [Location : Timestamp] = [:]
    @State private var didLoadVisits = false
    @State private var visitCount = 0
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    AvatarView(type: .profile, user: global.user)
                        .listRowBackground(Color.clear)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical)
                }
                .listRowSeparator(.hidden)
                
                navLinks
                
                vistitedLocationsView
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
            .task {
                try? await fetchUserVisits()
            }
            .onAppear {
                withAnimation {
                    visitCount = global.user.visits
                }
            }
            .fullScreenCover(isPresented: $showSubmitRequest) {
                SubmitLocationDetailsView(showCover: $showSubmitRequest)
            }
        }
    }
    
    @ViewBuilder
    var navLinks: some View {
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
        
        Button("Submit Location", systemImage: "map") {
            showSubmitRequest.toggle()
        }
    }
    
    @ViewBuilder
    var vistitedLocationsView: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("\(visitCount)")
                    .contentTransition(.numericText())
                Text("Locations Visited ")
            }
            .padding(.top)
            .font(.title3.bold())
            
            Text("Earn points for visiting haunted locations, climb the leaderboard, and unlock exclusive rewards.")
                .font(.footnote)
                .foregroundStyle(.gray)
        }
        
        if visitedLocations.isEmpty {
            Label("No Visits Yet", systemImage: "house.lodge")
                .frame(maxWidth: .infinity, alignment: .center)
                .listRowSeparator(.hidden, edges: .bottom)
                .foregroundStyle(.primary)
        } else {
            ForEach(Array(visitedLocations.keys), id: \.id) { location in
                if let date = visitedLocations[location] {
                    ZStack(alignment: .leading) {
                        VistItemView(location: location, visitDate: date)
                        NavigationLink(destination: LocationView(location: location)) {
                            EmptyView()
                        }
                        .opacity(0.0)
                    }
                }
            }
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets())
        }
    }
    
    func fetchUserVisits() async throws {
        do {
            guard let user = Auth.auth().currentUser else { return }
            
            var locationVisits: [Location : Timestamp] = [:]
            
            let visits = try await VisitService.shared.fetchVisits(userId: user.uid)
            let locationIds = visits.compactMap { $0.locationId }
            
            let locations = try modelContext.fetch(FetchDescriptor(predicate: #Predicate<Location> {
                locationIds.contains($0.id)
            }))
            
            for visit in visits {
                if let index = locations.firstIndex(where: { $0.id == visit.locationId } ) {
                    locationVisits[locations[index]] = visit.timestamp
                }
            }
            
            visitedLocations = locationVisits
            didLoadVisits = true
        } catch {
            print("Error: fetchUserVisits(): \(error.localizedDescription)")
        }
    }
}

#Preview {
    ProfileView()
        .environment(AuthModel())
        .environment(GlobalModel(user: .example))
}
