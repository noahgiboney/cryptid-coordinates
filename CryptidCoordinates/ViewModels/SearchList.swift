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
        
        func getCityCameraPosition(for city: String) -> MapCameraPosition {
            if let index = HauntedLocation.allLocations.firstIndex(where: { location in
                location.city == city
            }){
                let coords = HauntedLocation.allLocations[index].cityCoordinates
                return .region(MKCoordinateRegion(center: coords, span: MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.15)))
            }
            return MapCameraPosition.automatic
        }
    }
}
