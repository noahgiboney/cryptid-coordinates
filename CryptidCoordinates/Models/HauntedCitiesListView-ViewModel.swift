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
        
        var uniqueCities: [HauntedLocation] {
            
            var hauntedCities = [HauntedLocation]()
            
            for i in HauntedLocation.allLocations {
                if !hauntedCities.contains(where: { j in
                    i.city == j.city
                }) {
                    hauntedCities.append(i)
                }
            }
            return hauntedCities.sorted { $0.city < $1.city }
        }
    }
}
