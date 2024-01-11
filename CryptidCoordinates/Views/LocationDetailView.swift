//
//  LocationDetail.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 1/9/24.
//

import SwiftUI

struct LocationDetailView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var location: HauntedLocation
    
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack(alignment: .leading, spacing: 20){
                    
                    Text("\(location.city), \(location.country)")
                        .italic()
                        .font(.caption)
                    
                    Divider()
                    
                    Label(
                        title: { Text("Detailed Accout:") },
                        icon: { Image(systemName: "doc.text.magnifyingglass") }
                    )
                    .font(.title2.bold())
                                        
                    Text(location.description)
                    
                    Divider()
                    
                }
                .padding()
            }
            .navigationTitle(location.name)
            .toolbar {
                ToolbarItem(placement: .topBarLeading){
                    Button("Close") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing){
                    Button {
                        
                    } label: {
                        Text("Save")
                        Image(systemName: "square.and.arrow.down")
                    }
                }
            }
        }
    }
}

#Preview {
    LocationDetailView(location: HauntedLocation.example)
}
