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
        var savedLocations = [HauntedLocation]()
        
        // sheet
        var showingDetails = false
        var tappedLocation: HauntedLocation?
        
        
        // load locations from app storage
        func loadSavedLocations() {
            let url = URL.documentsDirectory.appending(component: "savedLocations")
            
            guard let data = try? Data(contentsOf: url) else {
                savedLocations = []
                return
            }
            
            let decoder = JSONDecoder()
            
            do{
                savedLocations = try decoder.decode([HauntedLocation].self, from: data)
            } catch {
                print("unable to decode saved locations from documents" + error.localizedDescription)
            }
        }
    }
}
