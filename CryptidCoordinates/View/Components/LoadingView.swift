//
//  LoadingView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 7/19/24.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack(spacing: 10){
            ProgressView()
            Text("Loading...")
                .foregroundStyle(.gray)
        }
    }
}

#Preview {
    LoadingView()
}
