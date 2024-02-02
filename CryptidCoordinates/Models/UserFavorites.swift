//
//  UserFavorites.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 1/29/24.
//
import Observation
import SwiftUI

@Observable
class UserFavorites {
    var locations: [HauntedLocation] = []
    
    // check if some location is already in array
    func isInFavorites(location: HauntedLocation) -> Bool {
        for index in locations {
            if index.coordinates == location.coordinates{
                return true
            }
        }
        return false
    }
    
    // add a location to top of list
    func add(_ location: HauntedLocation) {
        locations.append(location)
    }
    
    // remove a location
    func remove(_ location: HauntedLocation) {
        if let index = locations.firstIndex(of: location) {
            locations.remove(at: index)
        }
    }
}
