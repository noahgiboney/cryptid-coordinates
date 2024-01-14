//
//  HauntedCitiesListView-ViewModel.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 1/13/24.
//

import Foundation

extension HauntedCitiesListView {
    @Observable class ViewModel{
        
        var searchText = ""
        
        var hauntedCities: [String] {
            
            // build array of only cities
            let cities = HauntedLocation.locations.map { $0.city }
            
            let removedDuplicateCities = Set(cities)
            
            // return array of all possible haunted cities
            return Array(removedDuplicateCities).sorted { $0 < $1 }
        }
    }
}
