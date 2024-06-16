//
//  RequestCoordinates.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/16/24.
//

import MapKit
import SwiftUI

struct RequestMapView: View {
    @Environment(RequestModel.self) var requestModel
    
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
            })
            .navigationTitle("Find \(requestModel.locationName)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if requestModel.coordinates != nil {
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink("Next") {
                            RequestSubmitView()
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    RequestMapView()
        .environment(RequestModel())
}
