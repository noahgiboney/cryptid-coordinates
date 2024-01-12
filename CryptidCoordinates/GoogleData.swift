//
//  GoogleData.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 1/11/24.
//

import Foundation

// Root struct for the Google Custom Search API response
struct GoogleSearchResponse: Codable {
    let items: [SearchItem]?
}

// Struct for each search item
struct SearchItem: Codable {
    let title: String?
    let link: String?
    let pagemap: PageMap?
}

// Struct for the pagemap section which can contain image information
struct PageMap: Codable {
    let cse_image: [CSEImage]?

    struct CSEImage: Codable {
        let src: String?
    }
}
