//
//  ViewModel.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/14/24.
//

import Firebase
import SwiftUI

@Observable
class GlobalModel {
    
    init(user: User) {
        self.user = user
    }
    
    var user: User
    var tabSelection = 0
    
    var selectedLocation: Location? {
        didSet {
            tabSelection = 1
        }
    }
}
