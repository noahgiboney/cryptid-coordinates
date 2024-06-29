//
//  GoogleModel.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 1/11/24.
//

import Foundation

struct GoogleModel: Codable {
    let title: [String?]
    let description: [String?]
}

struct ItemsData{
    var allItems: [GoogleModel]
}

struct GoogleImage: Codable {
    let image: [String?]
}

struct ImageData {
    var allImage: [GoogleImage]
}
