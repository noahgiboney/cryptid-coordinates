//
//  SearchListView-ViewModel.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 1/14/24.
//

import MapKit
import SwiftUI

extension SearchListView {
    @Observable
    class ViewModel {
        
        //text to search for in list
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
        
        
        // returns the city cordinates for some city string given
        func getCordFor(for city: String) -> CLLocationCoordinate2D {
            if let index = HauntedLocation.allLocations.firstIndex(where: { location in
                location.city == city
            }){
                return HauntedLocation.allLocations[index].cityCoordinates
            }
            return CLLocationCoordinate2D()
        }
    }
}
