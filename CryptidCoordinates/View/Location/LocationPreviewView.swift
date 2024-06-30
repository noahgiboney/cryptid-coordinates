//
//  LocationPreviewView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/14/24.
//

import Kingfisher
import SwiftUI

struct LocationPreviewView: View {
    let location: Location
    
    var body: some View {
        VStack(alignment: .leading) {
            KFImage(location.url)
                .resizable()
                .scaledToFit()
                .shadow(color: Color.black.opacity(0.6), radius: 10, x: 0, y: 5)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
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
                        Image(systemName: "heart")
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
        .padding(.vertical, 25)
        .padding(.horizontal, 25)
        .contextMenu {
            Button("View On Map", systemImage: "map") {
                //
            }
            
            Button("Favorite", systemImage: "heart") {
                //
            }
        }
    }
}

#Preview {
    LocationPreviewView(location: Location.example)
}
