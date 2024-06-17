//
//  RequestCoordinates.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/16/24.
//

import MapKit
import SwiftUI
import TipKit

struct PickCordView: View {
    @Environment(SubmitLocationViewModel.self) var requestModel
    
    var body: some View {
        MapReader { reader in
            Map {
                if let cordinates = requestModel.coordinates {
                    Annotation("", coordinate: cordinates) {
                        Image(systemName: "mappin.circle")
                            .imageScale(.large)
                            .transition(.scale)
                    }
                }
            }
            .onTapGesture(perform: { screenCoord in
                let pinLocation = reader.convert(screenCoord, from: .local)
                withAnimation {
                    requestModel.coordinates = pinLocation
                }
                Task { await PickCordTip.pickCordEvent.donate() }
            })
            .navigationTitle("Pick Coordinates")
            .navigationBarTitleDisplayMode(.inline)
            .overlay(alignment: .top) {
                TipView(PickCordTip.tip)
                    .padding()
            }
            .toolbar {
                if requestModel.coordinates != nil {
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink("Next") {
                            SubmitView()
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    PickCordView()
        .environment(SubmitLocationViewModel())
}
