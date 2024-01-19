//
//  HeaderView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 1/18/24.
//

import SwiftUI

struct HeaderView: View {
    
    var locationName: String
    
    var body: some View {
        
        Label(locationName, systemImage: "mappin")
            .font(.title2)
            .padding(.horizontal, 30)
            .frame(height: 50)
            .background(.ultraThinMaterial)
            .clipShape(.rect(cornerRadius: 10))
            
    }
}

#Preview {
    HeaderView(locationName: HauntedLocation.example.name)
}
