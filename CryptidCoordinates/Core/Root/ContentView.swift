//
//  ContentView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/12/24.
//

import FirebaseFirestore
import FirebaseCore
import SwiftUI

struct ContentView: View {
    var body: some View {
        Button("Upload") {
            uploadJSON()
        }
    }
    
    func uploadJSON() {
        do {
            let locations = Locations.allLocations
            let db = Firestore.firestore()
            
            for item in locations {
                do {
                    let docRef = db.collection("locations").document(UUID().uuidString)
                    if let enc = try? Firestore.Encoder().encode(item) {
                        try docRef.setData(enc)
                        print("Document \(item.id) successfully written!")
                    } else {
                        print("Error encoding item at index \(index): \(item)")
                    }
                } catch {
                    print("Error writing document at index \(index) for item \(item.id): \(error)")
                }
            }
            
            print("Data successfully uploaded to Firestore!")
        } catch {
            print("Error reading or uploading JSON data: \(error)")
        }
    }
}

extension String {
    func replacingSpacesWithHyphens() -> String {
        return self.replacingOccurrences(of: " ", with: "-")
    }
}

#Preview {
    ContentView()
}
