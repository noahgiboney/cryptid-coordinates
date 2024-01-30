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
    
    func isInFavorites(location: HauntedLocation) -> Bool {
        for index in locations {
            if index.coordinates == location.coordinates{
                return true
            }
        }
        return false
    }
}
