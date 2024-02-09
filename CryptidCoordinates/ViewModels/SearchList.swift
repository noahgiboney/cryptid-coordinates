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
    enum SearchType: String {
        case city, location
    }
    
    struct SearchItem: Identifiable, Comparable {
        var id = UUID()
        var text: String
        var cityState: String?
        var coordinates: CLLocationCoordinate2D?
        
        static func <(lhs: SearchItem, rhs: SearchItem) -> Bool{
            return lhs.text < rhs.text
        }
    }
    
    @Observable
    class ViewModel {
        
        // text to search for in list
        var searchText = ""
        
        //
        var showingDetails = false
        
        var location: HauntedLocation?
        
        // selection for type of list
        var searchSelection: SearchType = .city
        
        //dynamically returns list based on searchText
        var searchList: [SearchItem] {
            
            var list: [SearchItem]
            
            switch searchSelection {
            case .city:
                
                let allCities = Array((Set(HauntedLocation.allLocations.map{ $0.cityState})))
                
                list = allCities.map {SearchItem(text: $0)}.sorted()
                
            case .location:
                list = HauntedLocation.allLocations.map {
                    SearchItem(text: $0.name, cityState: $0.cityState, coordinates: $0.coordinates)}
            }
            
            // filter list based on term
            return list.filter({ term in
                term.text.localizedCaseInsensitiveContains(searchText)
            })
        }
        
        // returns cordinates for city or location based on search selection
        func getCordFor(for place: SearchItem) -> CLLocationCoordinate2D {
            
            switch searchSelection {
            case .city:
                if let index = HauntedLocation.allLocations.firstIndex(where: { location in
                    location.cityState == place.text
                }){
                    return HauntedLocation.allLocations[index].cityCoordinates
                }
            case .location:
                if let index = HauntedLocation.allLocations.firstIndex(where: { location in
                    location.name == place.text && location.cityState == place.cityState
                }){
                    return HauntedLocation.allLocations[index].coordinates
                }
            }
            return CLLocationCoordinate2D()
        }
        
        func searchItemToLocation(item: SearchItem){
            if item.coordinates != nil{
                location =  HauntedLocation.allLocations.first{ location in
                    item.coordinates == location.coordinates
                }
            }
        }
    }
}
