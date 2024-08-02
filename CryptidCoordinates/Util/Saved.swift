//
//  Saved.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 7/26/24.
//

import SwiftUI

@Observable
class Saved {
    private let key = "saved"
    
    var locations: Set<String> {
        didSet {
            save()
        }
    }
    
    init() {
        if let data = UserDefaults.standard.data(forKey: key) {
            locations = (try? JSONDecoder().decode(Set<String>.self, from: data)) ?? []
        } else {
            locations = []
        }
    }
    
    func contains(_ location: Location) -> Bool {
        locations.contains(location.id)
    }
    
    func update(_ location: Location) {
        withAnimation {
            if contains(location) {
                locations.remove(location.id)
            } else {
                locations.insert(location.id)
            }
        }
    }
    
    private func save() {
        if let data = try? JSONEncoder().encode(locations) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}
