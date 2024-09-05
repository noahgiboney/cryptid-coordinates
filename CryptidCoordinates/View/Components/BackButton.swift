//
//  BackButton.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 7/7/24.
//

import SwiftUI

struct BackButton: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "chevron.left")
                .fontWeight(.semibold)
        }
    }
}

#Preview {
    BackButton()
}
