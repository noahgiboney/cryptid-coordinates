//
//  TopRatedView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/14/24.
//

import SwiftUI

struct LocationPreviewView: View {
    let location: OldLocation
    
    var body: some View {
        VStack(alignment: .leading) {
            
            NavigationLink {
                LocationDetailView(location: location)
            } label: {
                Image(._360F527962462ZBAIJXHDfHGdnwLrOs2QrJkETb9Kah4B)
                    .resizable()
                    .scaledToFit()
                    .shadow(radius: 5)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
            }
            
            VStack(alignment: .leading) {
                HStack{
                    Text(location.name)
                        .font(.headline)
                    
                    Spacer()
                    
                    HStack {
                        Image(systemName: "hand.thumbsup")
                        Text("\(55)")
                    }
                }
                
                Text(location.cityState)
                    .foregroundStyle(.gray)
                
                Text(location.description)
                    .font(.footnote)
                    .lineLimit(2)
                    .truncationMode(.tail)
                    .padding(.top, 1)
            }
        }
        .padding(.horizontal, 25)
        .foregroundStyle(.black)
    }
}

#Preview {
    LocationPreviewView(location: OldLocation.example)
}
