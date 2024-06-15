//
//  HomeView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/14/24.
//

import Firebase
import SwiftUI

struct HomeView: View {
    @Environment(ViewModel.self) var viewModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack{
                    Text("Trending")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    ScrollView(.horizontal) {
                        LazyHStack{
                            ForEach(OldLocation.exampleArray) { location in
                                TopRatedView(location: location)
                            }
                        }
                    }
                    
                    Button("do") {
                        uploadJSON()
                    }
                }
                .padding(.leading)
            }
            .navigationTitle("Cryptid Coordinates")
        }
    }
    
    func uploadJSON() {
        
        var locations = Bundle.main.newDecode(file: "hauntedplaces.json")
        
        do {
            let db = Firestore.firestore()
            
            for var location in locations {
                do {
                    let id = UUID().uuidString
                    location.id = id
                    
                    // Ensure the document ID does not contain slashes
                    let docRef = db.collection("locations").document(id)
                    if let enc = try? Firestore.Encoder().encode(location) {
                        docRef.setData(enc) { error in
                            if let error = error {
                                print("Error writing document \(id): \(error)")
                            } else {
                                print("Document \(id) successfully written!")
                            }
                        }
                    } else {
                        
                    }
                } catch {
                    print("Error writing document at ")
                }
            }
            
            print("Data successfully uploaded to Firestore!")
        } catch {
            print("Error reading or uploading JSON data: \(error)")
        }
    }
}

#Preview {
    HomeView()
        .environment(ViewModel(client: FirestoreClient()))
}
