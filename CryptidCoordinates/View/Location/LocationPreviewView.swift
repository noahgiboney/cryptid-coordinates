//
//  TopRatedView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/14/24.
//

import SwiftUI

struct LocationPreviewView: View {
    let location: Location
    
    var body: some View {
        VStack(alignment: .leading) {
            NavigationLink {
                LocationDetailView(location: location)
            } label: {
                Image(._360F527962462ZBAIJXHDfHGdnwLrOs2QrJkETb9Kah4B)
                    .resizable()
                    .scaledToFit()
                    .shadow(color: Color.black.opacity(0.6), radius: 10, x: 0, y: 5)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
            }
            
            VStack(alignment: .leading) {
                HStack{
                    Text(location.name)
                        .font(.headline)
                    
                    Spacer()
                    
                    HStack {
                        Text("523")
                        Image(systemName: "message")
                            .foregroundStyle(Color("AccentColor"))
                    }
                    
                    HStack {
                        Text("\(55)")
                        Image(systemName: "hand.thumbsup")
                            .foregroundStyle(Color("AccentColor"))
                    }
                }
                
                Text(location.cityState)
                    .foregroundStyle(.gray)
                    .font(.subheadline)
                
                Text(location.description)
                    .font(.footnote)
                    .lineLimit(2)
                    .truncationMode(.tail)
                    .padding(.top, 1)
            }
        }
        .padding(.horizontal, 25)
    }
}

#Preview {
    LocationPreviewView(location: Location.example)
}
