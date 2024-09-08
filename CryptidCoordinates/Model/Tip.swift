//
//  Tip.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/16/24.
//

import Foundation
import TipKit

struct VisitTip: Tip {
    static let tip = VisitTip()
    
    static let viewLocationEvent = Event(id: "viewLocation")
    
    var title: Text {
        Text("Visit Locations")
    }
    
    var message: Text? {
        Text("Upon arriving at a location, click visit to scan for paranormal activity. If detected, you will earn a visit.")
    }
    
    var image: Image? {
        Image(systemName: "mappin.and.ellipse")
    }
    
    var rules: [Rule] {
        #Rule(Self.viewLocationEvent) { event in
            event.donations.count == 2
        }
    }
}

struct PickCordTip: Tip {
    static let tip = PickCordTip()
    
    static let pickCordEvent = Event(id: "pickCord")
    
    var title: Text {
        Text("Add Coordinates")
    }
    
    var message: Text? {
        Text("Find and tap the location on the map. Try to be as precise as possible.")
    }
    
    var image: Image? {
        Image(systemName: "mappin")
    }
    
    var rules: [Rule] {
        #Rule(Self.pickCordEvent) { event in
            event.donations.count == 0
        }
    }
}
