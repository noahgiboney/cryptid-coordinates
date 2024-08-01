//
//  ScanningView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 8/1/24.
//

import SwiftUI

struct ScanningView: View {
    var body: some View {
        Image(systemName: "waveform")
            .imageScale(.large)
            .scaleEffect(2)
            .symbolEffect(.variableColor, options: .speed(2.0))
            .foregroundStyle(.accent)
    }
}

#Preview {
    ScanningView()
}
