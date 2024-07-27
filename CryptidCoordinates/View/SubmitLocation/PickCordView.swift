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
    @Binding var showCover: Bool
    @Environment(SubmitLocationModel.self) var submitModel
    @State private var position: MapCameraPosition = .region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 39, longitude: -98), span: MKCoordinateSpan(latitudeDelta: 40, longitudeDelta: 40)))
    
    var body: some View {
        MapReader { reader in
            Map(position: $position) {
                if let cordinates = submitModel.coordinates {
                    Annotation("", coordinate: cordinates) {
                        Image(systemName: "mappin")
                            .scaleEffect(2.0)
                            .foregroundStyle(.black)
                    }
                }
            }
            .mapStyle(.imagery)
            .onTapGesture(perform: { screenCoord in
                let pinLocation = reader.convert(screenCoord, from: .local)
                withAnimation(.easeOut){
                    if let pinCords = pinLocation{
                        position = .region(MKCoordinateRegion(center: pinCords, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)))
                    }
                    submitModel.coordinates = pinLocation
                }
                Task { await PickCordTip.pickCordEvent.donate() }
            })
            .navigationTitle("Pick Coordinates")
            .navigationBarTitleDisplayMode(.inline)
            .overlay(alignment: .top) {
                TipView(PickCordTip.tip)
                    .padding()
                
                if let cords = submitModel.coordinates {
                    Text("(\(cords.latitude), \(cords.longitude))")
                        .padding()
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 15))
                        .padding(.top)
                        .font(.headline)
                        .foregroundStyle(.white)
                }
            }
            .toolbar {                
                if submitModel.coordinates != nil {
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink("Next"){
                            SubmitView(showCover: $showCover)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        PickCordView(showCover: .constant(true))
            .environment(SubmitLocationModel())
    }
}
