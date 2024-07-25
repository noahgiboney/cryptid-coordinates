//
//  VisitView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 7/16/24.
//

import Firebase
import SwiftUI

enum VisitState {
    case scanning, newVisit, notInProximity, alreadyVisited
}

struct VisitView: View {
    var location: Location
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var locationManager: LocationManager
    @Environment(GlobalModel.self) var global
    @State private var visitState: VisitState = .scanning
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 40) {
                if locationManager.lastKnownLocation == nil {
                    LocationUnavailableView(message: "Share your location to visit")
                } else {
                    switch visitState {
                    case .scanning:
                        RadarView()
                    case .newVisit:
                        successView
                    case .notInProximity:
                        failView
                    case .alreadyVisited:
                        alreadyVisitedView
                    }
                }
            }
            .navigationTitle(visitState == .scanning ? "Scanning" : "Visit")
            .navigationBarTitleDisplayMode(.inline)
            .padding(.horizontal)
            .task {
                await checkDidVisit()
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
    
    var alreadyVisitedView: some View {
        VStack(spacing: 25) {
            Image(systemName: "house.lodge")
                .foregroundStyle(.gray)
                .imageScale(.large)
                .scaleEffect(2)
            
            VStack(alignment: .center, spacing: 4) {
                Text("You Already Visted This Location")
                    .font(.title2.bold())
                
                Text("Visit other haunted locations to earn more visits.")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }
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
                
                Text("You have now entered the realm of the paranormal. Watch your back and don't forget to share your experience on the location.")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }
            
            VStack(spacing: 10){
                Text("+1 Visit")
                    .font(.headline)
                    .transition(.scale)
                
                Text("You have now visited \(global.user.visits) haunted locations.")
                    .contentTransition(.numericText(value: Double(global.user.visits)))
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
    
    func checkDidVisit() async {
        guard let user = Auth.auth().currentUser else { return }
        guard let userCords = locationManager.lastKnownLocation else { return }
        
        do {
            let alreadyVisited = try await VisitService.shared.checkDidVisist(userId: user.uid, locationId: location.id)
            
            if alreadyVisited {
                visitState = .alreadyVisited
                return
            }
            
            try await Task.sleep(nanoseconds: 1_500_000_000)
            
            /// 0.3 miles 483
            let minDistance = 10000.0
            
            let distanceFromLocation = userCords.distance(from: location.clLocation)

            if distanceFromLocation <= minDistance {
                visitState = .newVisit
            } else {
                visitState = .notInProximity
            }
            
            
        } catch {
            print("Error: checkDidVisit(): \(error.localizedDescription)")
        }
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
