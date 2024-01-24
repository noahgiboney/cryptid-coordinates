//
//  SearchListView-ViewModel.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 1/14/24.
//

import MapKit
import SwiftUI

extension SearchListView {
    
    enum ListType: String {
        case city, location
    }
    
    @Observable
    class ViewModel {
        
        //text to search for in list
        var searchText = ""
        
        var searchSelection: ListType = .city
        
        var searchList: [String] {
            
            var cityList = [String]()
            
            switch searchSelection {
            case .city:
               cityList = Array(Set(HauntedLocation.allLocations.map {$0.city})).sorted()
            case .location:
                cityList = HauntedLocation.allLocations.map { $0.location}.sorted()
            }
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
