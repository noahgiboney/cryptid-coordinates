//
//  NewLocationCellView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 9/7/24.
//

import Firebase
import Kingfisher
import SwiftData
import SwiftUI

struct NewLocationCellView: View {
    
    let newLocation: NewLocation
    let user: User
    @Environment(\.colorScheme) var colorScheme
    @Environment(LocationStore.self) var store
    @Query var locations: [Location]
    
    init(newLocation: NewLocation, user: User) {
        self.newLocation = newLocation
        self.user = user
        self._locations = .init(filter: #Predicate {
            $0.id == newLocation.id
        })
    }
    
    private var location: Location? {
        locations.first
    }
    
    var body: some View {
        VStack(spacing: 10) {
            HStack(alignment: .bottom) {
                NavigationLink {
                    UserProfileScreen(user: user)
                } label: {
                    HStack(alignment: .bottom) {
                        AvatarView(type: .medium, user: user)
                        Text("Submitted by \(user.username)")
                            .font(.system(size: 14).italic())
                            .foregroundStyle(colorScheme == .light ? .black : .white)
                    }
                }
                
                Spacer()
                            
                Text(newLocation.timestamp.timeAgo())
                    .foregroundStyle(.gray)
                    .font(.footnote.italic())
            }
            .padding(.horizontal)
            
            if let location = location {
                NavigationLink {
                    LocationContainer(location: location)
                } label: {
                    VerticalLocationPreview(location: location)
                }
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Location.self, configurations: config)
    
    return  NewLocationCellView(newLocation: .example, user: .example)
        .modelContainer(container)
}
