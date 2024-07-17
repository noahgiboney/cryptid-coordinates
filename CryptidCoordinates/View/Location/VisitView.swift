//
//  VisitView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 7/16/24.
//

import SwiftUI

struct VisitView: View {
    var location: Location
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var locationManager: LocationManager
    @State private var showCheckmark = false
    @State private var showRader = true
    
    var body: some View {
        NavigationStack {
            VStack {
                if locationManager.lastKnownLocation != nil {
                    LocationUnavailableView(message: "Share your location to visit")
                } else {
                    if showRader {
                        RadarView()
                    }
                }
            }
            .padding(.horizontal)
            .navigationTitle(showRader ? "Scanning" : "Visit")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
                    showRader = false
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    var checkmark: some View {
        Image(systemName: "checkmark")
            .scaleEffect(1.5)
            .foregroundStyle(.green)
            .imageScale(.large)
            .padding(25)
            .background {
                RoundedRectangle(cornerRadius: 15)
            }
    }
    
    var successView: some View {
        VStack(alignment: .leading, spacing: 10){
            Text("Paranormal Activity Detected!")
                .font(.title2.bold())
            
            Text("You are currently in proximity of paranomal activity. Watch your back and don't forget to share your experience on the location.")
        }
    }
    
    var failView: some View {
        VStack(spacing: 30){
            VStack(alignment: .leading, spacing: 10) {
                Text("You are too far away.")
                    .font(.title2.bold())
                
                Text("Move closer to seek paranormal activity. You are 15 miles away.")
            }
            
            Button {
                
            } label: {
                Label("Directions", systemImage: "location")
            }
            .buttonStyle(.bordered)
        }
    }
}

#Preview {
    VisitView(location: .example)
        .environmentObject(LocationManager())
}
