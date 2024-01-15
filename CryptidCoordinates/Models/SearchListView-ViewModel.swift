//
//  SearchListView-ViewModel.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 1/14/24.
//

import Foundation

extension SearchListView {
    @Observable
    class ViewModel {
        
        var searchText = ""
        
        var searchList: [String] {
            
            let cityList: [String] = Array(Set(HauntedLocation.allLocations.map {$0.city})).sorted()
            
            if searchText == "" {
                return cityList
            }
            else {
                
                return cityList.filter({ city in
                    city.localizedCaseInsensitiveContains(searchText)
                })
            }
        }
        
    }
}
