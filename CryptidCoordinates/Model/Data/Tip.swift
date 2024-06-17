//
//  Tip.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/16/24.
//

import Foundation
import TipKit

struct PickCordTip: Tip {
    static let tip = PickCordTip()
    
    static let pickCordEvent = Event(id: "pickCord")
    
    var title: Text {
        Text("Add Coordinates")
    }
    
    var message: Text? {
        Text("Tap your location on the map. Be as precise as possible.")
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
