import Foundation
import SwiftUI
import FirebaseFirestore
import Combine


@MainActor
class DeleteService {
    let db = Firestore.firestore()
    
    func deleteInvalidLocations() async throws {
        let snapshot = try await db.collection("locations").getDocuments()
        for document in snapshot.documents {
            if !isValidLocation(document: document) {
                print("Deleting document with ID: \(document.documentID)")
                try await deleteLocation(id: document.documentID)
            }
        }
    }
    
    private func isValidLocation(document: QueryDocumentSnapshot) -> Bool {
        do {
            _ = try document.data(as: DecodableLocation.self)
            return true
        } catch {
            print("Invalid document: \(document.documentID) - \(error)")
            return false
        }
    }
    
    private func deleteLocation(id: String) async throws {
        let docRef = db.collection("locations").document(id)
        try await docRef.delete()
        print("Deleted document with ID: \(id)")
    }
}

@MainActor
class UpdateService {
    let db = Firestore.firestore()
    
    func update() async throws {
        let locations: [DecodableLocation] = try await fetchLocations()
        var updateCount = 0
        print("Updating \(locations.count) locations")
        
        for location in locations {
            try await updateLocationInFirebase(location)
            print(updateCount)
            updateCount += 1
        }
    }
    
    func createJSONFileFromFirestore() {
        fetchFirestoreData()
    }

    func fetchFirestoreData() {
        let db = Firestore.firestore()
        db.collection("locations").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                var allData = [[String: Any]]()
                for document in querySnapshot!.documents {
                    if (try? document.data(as: DecodableLocation.self)) != nil {
                        allData.append(document.data())
                    }
                }
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: allData, options: .prettyPrinted)
                    self.saveJSONToFile(jsonData: jsonData)
                } catch {
                    print("Error converting data to JSON: \(error)")
                }
            }
        }
    }
    
    func saveJSONToFile(jsonData: Data) {
        let fileManager = FileManager.default
        do {
            let documentDirectory = try fileManager.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            )
            let jsonFilePath = documentDirectory.appendingPathComponent("collectionData.json")
            try jsonData.write(to: jsonFilePath)
            print("JSON file saved at: \(jsonFilePath)")
        } catch {
            print("Error saving JSON file: \(error)")
        }
    }
    
    private func fetchLocations() async throws -> [DecodableLocation] {
        let snapshot = try await db.collection("locations").getDocuments()
        return snapshot.documents.compactMap { document in
            try? document.data(as: DecodableLocation.self)
        }
    }
    
    private func fetchRandomLocations() async throws -> [DecodableLocation] {
        let randomUUID = UUID().uuidString
        let firstQuery = db.collection("locations")
            .whereField("id", isGreaterThanOrEqualTo: randomUUID)
            .order(by: "id")
            .limit(to: 1000)
        
        let firstSnapshot = try await firstQuery.getDocuments()
        var documents = firstSnapshot.documents
        
        if documents.count < 1000 {
            let remainingCount = 1000 - documents.count
            let secondQuery = db.collection("locations")
                .whereField("id", isLessThan: randomUUID)
                .order(by: "id")
                .limit(to: remainingCount)
            
            let secondSnapshot = try await secondQuery.getDocuments()
            documents.append(contentsOf: secondSnapshot.documents)
        }
        
        return documents.compactMap { document in
            try? document.data(as: DecodableLocation.self)
        }
    }
    
    private func updateLocationInFirebase(_ location: DecodableLocation) async throws {
        let docRef = db.collection("locations").document(location.id)
        try docRef.setData(from: location, merge: false)
    }
}

@MainActor
class LocationUpdateManager: ObservableObject {
    @Published var isUpdating = false
    @Published var errorMessage: String?
    
    func updateLocations() {
        isUpdating = true
        errorMessage = nil
        
        Task {
            do {
                let updater = UpdateService()
                try await updater.update()
                isUpdating = false
            } catch {
                errorMessage = "Failed to update locations: \(error)"
                isUpdating = false
            }
        }
    }
    
    func createJSONFile() {
        isUpdating = true
        errorMessage = nil
        
        let updater = UpdateService()
        updater.createJSONFileFromFirestore()
        isUpdating = false
    }
    
    func deleteInvalidLocations() {
        isUpdating = true
        errorMessage = nil
        
        Task {
            do {
                let deleter = DeleteService()
                try await deleter.deleteInvalidLocations()
                isUpdating = false
            } catch {
                errorMessage = "Failed to delete invalid locations: \(error)"
                isUpdating = false
            }
        }
    }
}

struct UpdateView: View {
    @StateObject private var locationUpdateManager = LocationUpdateManager()
    @State private var timer: AnyCancellable?
    
    var body: some View {
        VStack {
            if locationUpdateManager.isUpdating {
                ProgressView("Updating locations...")
            } else {
                VStack {
                    Button(action: {
                        locationUpdateManager.updateLocations()
                    }) {
                        Text("Update Locations")
                    }
                    Button(action: {
                        locationUpdateManager.createJSONFile()
                    }) {
                        Text("Create JSON File")
                    }
                    Button(action: {
                        locationUpdateManager.deleteInvalidLocations()
                    }) {
                        Text("Delete Invalid Locations")
                    }
                }
            }
            
            if let errorMessage = locationUpdateManager.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
        }
        .padding()
        .onAppear {
            startTimer()
        }
        .onDisappear {
            stopTimer()
        }
    }
    
    private func startTimer() {
        timer = Timer.publish(every: 180, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                locationUpdateManager.updateLocations()
            }
    }
    
    private func stopTimer() {
        timer?.cancel()
        timer = nil
    }
}

