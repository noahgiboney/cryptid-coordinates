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
    @Environment(\.colorScheme) var colorScheme
    @Environment(LocationStore.self) var store
    @Query var locations: [Location]
    
    init(newLocation: NewLocation) {
        self.newLocation = newLocation
        self._locations = .init(filter: #Predicate {
            $0.id == newLocation.id
        })
    }
    
    
    var body: some View {
        Group {
            if let location = locations.first {
                VStack(spacing: 0) {
                    userInfoView
                    
                    NavigationLink {
                        LocationContainer(location: location)
                    } label: {
                        VerticalLocationPreview(location: location)
                    }
                }
            }
        }
    }
    
    private var userInfoView: some View {
        HStack(alignment: .bottom) {
            if let user = newLocation.user {
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
            } else {
                HStack(alignment: .bottom) {
                    AvatarView(type: .medium, user: .example)
                    Text("Submitted by Anonymous")
                        .font(.system(size: 14).italic())
                }
            }
            
            Spacer()
            
            Text(newLocation.timestamp.timeAgo())
                .foregroundStyle(.gray)
                .font(.footnote.italic())
        }
        .padding(.horizontal)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Location.self, configurations: config)
    
    return  NewLocationCellView(newLocation: .example)
        .modelContainer(container)
}
