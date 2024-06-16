//
//  RequestModel.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 6/16/24.
//

import MapKit
import SwiftUI

@Observable
class RequestModel {
    var locationName = ""
    var description = ""
    var coordinates: CLLocationCoordinate2D?
}
