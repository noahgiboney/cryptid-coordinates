//
//  FeedbackScreen.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 9/8/24.
//

import Firebase
import SwiftUI

struct Feedback: DataModel {
    var id = UUID().uuidString
    var userId: String
    var feedback: String
    var timestamp = Timestamp()
}

struct FeedbackForm: View {
    
    @Environment(\.dismiss) var dismiss
    @State private var feedback = ""
    @State private var showingAlert = false
    
    private func uploadFeedback() async {
        guard let user = Auth.auth().currentUser else { return }
        
        do {
            let feedback = Feedback(userId: user.uid, feedback: feedback)
            try await FirebaseService.shared.setData(object: feedback, ref: Collections.feedback)
            showingAlert.toggle()
        } catch {
            print("Error: uploadFeedback(): \(error.localizedDescription)")
        }
    }
    
    var body: some View {
        Form {
            Text("Feedback, suggestions, or reports of bugs would be greatly appreciated!")
            TextField("Feedback", text: $feedback, axis: .vertical)
            
            Section {
                Button("Submit", systemImage: "paperplane") {
                    Task { await uploadFeedback() }
                }
                .buttonStyle(.borderless)
                .foregroundStyle(.blue)
            }
        }
        .navigationTitle("Feedback")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Thanks!", isPresented: $showingAlert) {
            Button("Ok") {
                dismiss()
            }
        } message: {
            Text("You feedback will be taken under consideration.")
        }
    }
    
}

#Preview {
    FeedbackForm()
}
