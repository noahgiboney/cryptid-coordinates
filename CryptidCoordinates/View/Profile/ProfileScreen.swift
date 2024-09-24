//
//  ProfileView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/15/24.
//

import Firebase
import SwiftData
import SwiftUI

struct ProfileScreen: View {
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.modelContext) var modelContext
    @Environment(Global.self) var global
    @Environment(AuthModel.self) var authModel
    @Environment(VisitStore.self) var visitStore
    @State private var didAppear = false
    
    private func fetchUserVisits() async {
        do {
            let userVisits = try await visitStore.fetchVisits(for: global.user.id)
            let locationIds = userVisits.compactMap { $0.locationId }
            
            let locations = try modelContext.fetch(FetchDescriptor(predicate: #Predicate<Location> {
                locationIds.contains($0.id)
            }))
            
            visitStore.mapCurrentUserVists(locations: locations, visits: userVisits)
        } catch {
            print("Error: fetchUserVisits(): \(error.localizedDescription)")
        }
    }
    
    private var visits: [Location: Timestamp] {
        visitStore.userVisits
    }
    
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
                    NavigationLink {
                        SettingsForm()
                    } label: {
                        Label("Settings", systemImage: "gearshape")
                    }
                }
            }
            .task { await fetchUserVisits() }
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
            SavedView()
        } label: {
            Label("Saved", systemImage: "bookmark")
        }
    }
    
    @ViewBuilder
    var vistitedLocationsView: some View {
        VStack(alignment: .leading) {
            Text("\(global.user.visits) Locations Visited")
                .padding(.top)
                .font(.title3.bold())
            
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
            ScrollView(.vertical,  showsIndicators: false) {
                LazyVGrid(columns: [GridItem(), GridItem()]) {
                    ForEach(Array(visits.keys.sorted { visits[$0]!.dateValue() > visits[$1]!.dateValue() }), id: \.id) { location in
                        if let date = visits[location] {
                            VisitPreviewView(location: location, visitDate: date)
                        }
                    }
                }
                
            }
            .contentMargins(5, for: .scrollContent)
            .listRowInsets(EdgeInsets())
            .listRowSeparator(.hidden)
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Location.self, configurations: config)
    
    return ProfileScreen()
        .environment(AuthModel())
        .environment(Global(user: .example, defaultCords: Location.example.coordinates))
        .modelContainer(container)
    
}
