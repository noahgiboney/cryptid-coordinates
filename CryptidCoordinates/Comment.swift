//
//  Comment.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/18/24.
//

import Firebase
import Foundation

struct Comment: Codable, Identifiable, Equatable {
    var id = UUID().uuidString
    var userId: String
    var locationId: String
    var content: String
    var timestamp = Timestamp()
    
    var user: User?
}

// MARK: Developer
extension Comment {
    static let example = Comment(id: UUID().uuidString, userId: UUID().uuidString, locationId: UUID().uuidString, content: "Such a cool place wow!", timestamp: Timestamp())
    
    static let exampleComments: [Comment] = [
        .init(userId: UUID().uuidString, locationId: UUID().uuidString, content: "Where is this place from wow it is ver cool,"),
        .init(userId: UUID().uuidString, locationId: UUID().uuidString, content: "I will go to this place soon, I will see how it is."),
        .init(userId: UUID().uuidString, locationId: UUID().uuidString, content: "Perched atop the cliffs of Nova Scotia, Canada, the ominous Oak Island exudes an eerie aura. Cloaked in dense fog, this remote island has been a focal point of mystery and fear for centuries. Legend whispers of hidden treasures and a deadly curse that claims the lives of those who seek it. The eerie silence is broken only by the waves crashing against jagged rocks and the rustle of wind through twisted trees. Visitors report ghostly apparitions, strange lights, and a pervasive sense of dread. Oak Island's haunted history and spine-chilling atmosphere make it one of the scariest places in the world.")]
    
    static let exampleArray: [Comment] = Array.init(repeating: .example, count: 5)
}

extension Timestamp {
    func timeAgo() -> String {
        let now = Date()
        let timeInterval = now.timeIntervalSince(self.dateValue())
        
        let minute: Double = 60
        let hour: Double = 3600
        let day: Double = 86400
        let week: Double = 604800
        
        if timeInterval < minute {
            return "\(Int(timeInterval))s"
        } else if timeInterval < hour {
            return "\(Int(timeInterval / minute))m"
        } else if timeInterval < day {
            return "\(Int(timeInterval / hour))h"
        } else if timeInterval < week {
            return "\(Int(timeInterval / day))d"
        } else {
            return "\(Int(timeInterval / week))w"
        }
    }
}