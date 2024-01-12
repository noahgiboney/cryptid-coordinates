//
//  WikipediaResponse.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 1/10/24.
//

import Foundation

struct WikipediaResponse: Codable {
    let query: Query
}

struct Query: Codable{
    let pages: [String: Page]
}

struct Page: Codable {
    let thumbnail: Thumbnail?
}

struct Thumbnail: Codable {
    let source: String
}
