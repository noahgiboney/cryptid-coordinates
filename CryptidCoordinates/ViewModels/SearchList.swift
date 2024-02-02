//
//  SearchListView-ViewModel.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 1/14/24.
//

import MapKit
import SwiftUI

extension SearchListView {
    
    // defines what list is showing to search over
    enum ListType: String {
        case city, location
    }
    
    // search through this nested struct
    struct SearchItem: Identifiable, Comparable {
        var id = UUID()
        var text: String
        
        static func <(lhs: SearchItem, rhs: SearchItem) -> Bool{
            return lhs.text < rhs.text
        }
    }
    
    @Observable
    class ViewModel {
        
        // text to search for in list
        var searchText = ""
        
        // selection for type of list
        var searchSelection: ListType = .city
        
        //dynamically returns list based on searchText
        var searchList: [SearchItem] {
            
            var list: [SearchItem]
            
            switch searchSelection {
            case .city:
                
                let allCities = Array((Set(HauntedLocation.allLocations.map{ $0.city})))
                
                list = allCities.map {SearchItem(text: $0)}.sorted()
                
            case .location:
                list = HauntedLocation.allLocations.map {
                    SearchItem(text: $0.name + ", " + $0.cityState)}
            }
            
            // filter list based on term
            return list.filter({ term in
                term.text.localizedCaseInsensitiveContains(searchText)
            })
        }
        
        // returns cordinates for city or location based on search selection
        func getCordFor(for place: String) -> CLLocationCoordinate2D {
            
            switch searchSelection {
            case .city:
                if let index = HauntedLocation.allLocations.firstIndex(where: { location in
                    location.city == place
                }){
                    return HauntedLocation.allLocations[index].cityCoordinates
                }
            case .location:
                if let index = HauntedLocation.allLocations.firstIndex(where: { location in
                    location.name == place
                }){
                    return HauntedLocation.allLocations[index].coordinates
                }
            }
            return CLLocationCoordinate2D()
        }
    }
}
