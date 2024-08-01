//
//  ProfileView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/15/24.
//

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
    @State private var visits: [Location : Timestamp] = [:]
    
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
            NavigationLink {
                AllVisitsView(visits: visits)
            } label: {
                Text("\(global.user.visits) Locations Visited")
                .padding(.top)
                .font(.title3.bold())
            }

            Text("Earn points for visiting haunted locations, climb the leaderboard, and unlock exclusive rewards.")
                .font(.footnote)
                .foregroundStyle(.gray)
        }
        
        if visits.isEmpty {
            Label("No Visits Yet", systemImage: "house.lodge")
                .frame(maxWidth: .infinity, alignment: .center)
                .listRowSeparator(.hidden, edges: .bottom)
                .foregroundStyle(.primary)
        } else {
            ScrollView(.horizontal,  showsIndicators: false) {
                LazyHStack {
                    ForEach(Array(visits.keys.sorted { visits[$0]!.dateValue() > visits[$1]!.dateValue() }).prefix(upTo: visits.count < 5 ? visits.count : 5), id: \.id) { location in
                        if let date = visits[location] {
                                VisitPreviewView(location: location, visitDate: date)
                                .scrollTransition { content, phase in
                                    content
                                        .scaleEffect(phase.isIdentity ? 1 : 0.75)
                                        .offset(y: phase.isIdentity ? 0 : 5)
                                        .opacity(phase.isIdentity ? 1 : 0.5)
                                }
                        }
                    }
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets())
                }
            }
            .contentMargins(5, for: .scrollContent)
            .listRowInsets(EdgeInsets())
            .listRowSeparator(.hidden)
        }
    }
    
    func fetchUserVisits() async throws {
        do {
            guard let user = Auth.auth().currentUser else { return }
            
            var locationVisits: [Location : Timestamp] = [:]
            
            let userVisits = try await VisitService.shared.fetchVisits(userId: user.uid)
            let locationIds = userVisits.compactMap { $0.locationId }
            
            let locations = try modelContext.fetch(FetchDescriptor(predicate: #Predicate<Location> {
                locationIds.contains($0.id)
            }))
            
            for visit in userVisits {
                if let index = locations.firstIndex(where: { $0.id == visit.locationId } ) {
                    locationVisits[locations[index]] = visit.timestamp
                }
            }
            
            visits = locationVisits
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
