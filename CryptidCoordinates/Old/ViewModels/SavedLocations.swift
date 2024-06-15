//
//  UserFavorites.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 2/2/24.
//

import Observation
import SwiftUI

extension SavedLocationsView{
    
    enum SortType: String {
        case newest, oldest
    }
    
    @Observable
    class ViewModel {
        
        // array of locations loaded from app storage
        var savedLocations = [Location]() {
            didSet {
                let url = URL.documentsDirectory.appending(component: "savedLocations")
                let data = try? JSONEncoder().encode(savedLocations)
                do {
                    try data?.write(to: url)
                    
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        
        // sheets
        var showingDetails = false
        var tappedLocation: Location?
        
        
        // load locations from app storage
        func loadSavedLocations() {
            let url = URL.documentsDirectory.appending(component: "savedLocations")
            
            guard let data = try? Data(contentsOf: url) else {
                savedLocations = []
                return
            }
            
            let decoder = JSONDecoder()
            
            do{
                savedLocations = try decoder.decode([Location].self, from: data)
            } catch {
                print("unable to decode saved locations from documents" + error.localizedDescription)
            }
        }
    }
}
