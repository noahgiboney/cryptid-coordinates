//
//  GoogleData.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 1/11/24.
//

import Foundation

struct GoogleSearchResponse: Codable {
    let items: [SearchItem]?
}

struct SearchItem: Codable {
    let title: String?
    let link: String?
    let pagemap: PageMap?
}

struct PageMap: Codable {
    let cseImage: [CSEImage]?

    struct CSEImage: Codable {
        let src: String?
    }
}
