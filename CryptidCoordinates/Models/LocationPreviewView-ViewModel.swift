//
//  LocationPreviewView-ViewModel.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 1/16/24.
//

import MapKit

extension LocationPreviewView {
    @Observable
    class ViewModel {
        
        var index = 0
        
        func slideLeft() {
            index -= 1
            
        }
        
        func slideRight() {
            index += 1
        }
        
    }
}
