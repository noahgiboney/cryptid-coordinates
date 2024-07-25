//
//  VisitView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 7/16/24.
//

import Firebase
import SwiftUI

struct VisitView: View {
    var location: Location
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var locationManager: LocationManager
    @Environment(GlobalModel.self) var global
    @State private var showCheckmark = false
    @State private var showRader = true
    @State private var didVisit = false
    @State private var visits = 0
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 40) {
                if locationManager.lastKnownLocation == nil {
                    LocationUnavailableView(message: "Share your location to visit")
                } else {
                    if showRader {
                        RadarView()
                            .onAppear {
                                checkDidVisit()
                            }
                    } else {
                        if didVisit {
                            successView
                        } else {
                            failView
                        }
                    }
                }
            }
            .navigationTitle(showRader ? "Scanning" : "Visit")
            .navigationBarTitleDisplayMode(.inline)
            .padding(.horizontal)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    showRader = false
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
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
        VStack(spacing: 25) {
            Image(systemName: "exclamationmark.triangle")
                .foregroundStyle(.gray)
                .imageScale(.large)
                .scaleEffect(2)
            
            VStack(alignment: .center, spacing: 4) {
                Text("Paranormal Activity Detected")
                    .font(.title2.bold())
                
                Text("Watch your back and don't forget to share your experience on the location.")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }
            
            VStack {
                Text("+1 Visit")
                    .font(.headline)
                    .transition(.scale)
                
                Text("You have visited 10 haunted locations!")
            }
        }
        .task {
            try? await logVisit(location.id)
        }
    }
    
    var failView: some View {
        VStack(spacing: 20) {
            Image(systemName: "waveform.badge.magnifyingglass")
                .foregroundStyle(.gray)
                .imageScale(.large)
                .scaleEffect(2)
            
            VStack(alignment: .center, spacing: 4) {
                Text("Keep Searching")
                    .font(.title2.bold())
                
                Text("Move closer to find paranormal activity.")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }
            
            
            if let userCords = locationManager.lastKnownLocation {
                VStack {
                    Text("\(location.distanceAway(userCords)) miles away from")
                    Text(("\(location.name)"))
                }
            }
            
            Button {
                
            } label: {
                Label("Directions", systemImage: "location")
            }
            .buttonStyle(.bordered)
        }
    }
    
    func checkDidVisit() {
        guard let userCords = locationManager.lastKnownLocation else { return }
        
        /// 0.3 miles
        let minDistance = 483.0
        
        let distanceFromLocation = userCords.distance(from: location.clLocation)

        didVisit = (distanceFromLocation <= minDistance)
    }
    
    func logVisit(_ locationId: String) async throws {
        guard let user = Auth.auth().currentUser else { return }
        
        let newVisit = Visit(userId: user.uid, locationId: locationId)
        
        do {
            global.user.visits += 1
            
            try await VisitService.shared.logVisit(visit: newVisit, visitCount: global.user.visits)
        } catch {
            print("Error: logVisit() : \(error.localizedDescription)")
        }
    }
}

#Preview {
    VisitView(location: .example)
        .environmentObject(LocationManager())
}
