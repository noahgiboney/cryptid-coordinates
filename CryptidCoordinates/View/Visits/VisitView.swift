//
//  VisitView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 7/16/24.
//

import Firebase
import MapKit
import StoreKit
import SwiftUI

enum VisitState {
    case scanning, newVisit, notInProximity, alreadyVisited
}

struct VisitView: View {

    let location: Location
    @AppStorage("lastVersionPromptedForReview") var lastVersionPromptedForReview = ""
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var locationManager: LocationManager
    @Environment(\.requestReview) var requestReview
    @Environment(GlobalModel.self) var global
    @State private var visitState: VisitState = .scanning
    @State private var visitCount = 0
    
    private func openInMaps(_ location: Location) {
        let item = MKMapItem(placemark: MKPlacemark(coordinate: location.coordinates))
        item.openInMaps()
    }
    
    private func checkDidVisit() async {
        guard let user = Auth.auth().currentUser else { return }
        guard let userCords = locationManager.lastKnownLocation else { return }
        
        do {
            
            async let alreadyVisited = Collections.userVists(for: user.uid).document(location.id).getDocument().exists
            
            async let scanning: Void = Task.sleep(nanoseconds: 1_500_000_000)
            
            let delay = try await (alreadyVisited, scanning)
            
            if delay.0 {
                visitState = .alreadyVisited
                return
            }
            
            /// 0.3 miles 483
            let minDistance = 483.0
            
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
    
    private func logVisit(_ locationId: String) async throws {
        guard let user = Auth.auth().currentUser else { return }
        
        let newVisit = Visit(userId: user.uid, locationId: locationId)
        
        do {
            global.user.visits += 1
            
            async let result1: Void = try await FirebaseService.shared.setData(object: newVisit, ref: Collections.userVists(for: user.uid))
            
            async let result2: Void = try await FirebaseService.shared.updateDataField(id: user.uid, field: "visits", value: global.user.visits, ref: Collections.users)
            
            _ = try await (result1, result2)
            
            if global.user.visits >= 1 && lastVersionPromptedForReview != global.currentAppVersion  {
                presentReview()
            }
        } catch {
            print("Error: logVisit() : \(error.localizedDescription)")
        }
    }
    
    private func presentReview() {
        Task {
            try await Task.sleep(for: .seconds(2.0))
            requestReview()
            lastVersionPromptedForReview = global.currentAppVersion
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 40) {
                if locationManager.lastKnownLocation == nil {
                    LocationUnavailableView(message: "Share your location to visit")
                } else {
                    switch visitState {
                    case .scanning:
                        ScanningView()
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
                    .font(.title3.bold())
                
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
                    .font(.title3.bold())
                
                Text("Something lingers here. Stay alert... and share what you uncover.")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }
            
            VStack(spacing: 10){
                Text("+1 Visit")
                    .font(.headline)
                    .transition(.scale)
                
                Text("You have now visited \(visitCount) haunted locations.")
                    .contentTransition(.numericText(value: Double(visitCount)))
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation {
                        visitCount = global.user.visits
                    }
                }
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
                Text("You are too far away")
                    .font(.title3.bold())
                
                Text("Move closer to \(location.name) to find paranormal activity.")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }
            
            
            if let userCords = locationManager.lastKnownLocation {
                Text("You are \(location.distanceAway(userCords)) miles away.")
            }
            
            Button {
                openInMaps(location)
            } label: {
                Label("Directions", systemImage: "location")
            }
            .buttonStyle(.bordered)
            .foregroundStyle(.blue)
        }
    }
}

#Preview {
    VisitView(location: .example)
        .environmentObject(LocationManager())
}
