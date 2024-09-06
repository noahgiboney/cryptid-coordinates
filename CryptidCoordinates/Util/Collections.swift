//
//  Collections.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 9/2/24.
//

import Firebase
import Foundation

struct Collections {
    
    private static let db = Firestore.firestore()
    
    static let comments = db.collection("comments")
    
    static let users = db.collection("users")
    
    static let visits = db.collection("visits")
    
    static let locationRequests = db.collection("locationRequests")
    
    static let reportedComments = db.collection("reportedComments")
    
    static let newLocations = db.collection("newLocations")
    
    static func userVists(for userId: String) -> CollectionReference {
        visits.document(userId).collection("visits")
    }
    
    static func locationComments(for locationId: String) -> CollectionReference {
        comments.document(locationId).collection("comments")
    }
}
