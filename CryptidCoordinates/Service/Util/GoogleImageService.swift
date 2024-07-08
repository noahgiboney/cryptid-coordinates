//
//  GoogleImageService.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 1/17/24.
//

import SwiftUI
import UIKit

enum GoogleAPIError: Error {
    case serverError, urlError, jsonError, responseError, noItemsFound
}

class GoogleImageService {
    static let shared = GoogleImageService()
    
    private init() {}
    
    func fetchImageUrl(for searchTerm: String) async throws -> String? {
        let endpoint = "https://www.googleapis.com/customsearch/v1?key=\("KEY")&cx=\("CX")&q=\(searchTerm)&searchType=image"
        //&rights=cc_publicdomain
        guard let url = URL(string: endpoint) else {
            print("URL Error: Invalid URL")
            throw GoogleAPIError.urlError
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            print("Server Error: \(response)")
            throw GoogleAPIError.serverError
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        do {
            let searchResult = try decoder.decode(GoogleSearchResponse.self, from: data)
            return try parseJSON(decodedData: searchResult)
        } catch {
            print("Response Error: Failed to decode JSON - \(error)")
            throw GoogleAPIError.responseError
        }
    }
    
    private func parseJSON(decodedData: GoogleSearchResponse) throws -> String? {
        guard let items = decodedData.items else {
            print("JSON Error: No items found in response")
            return nil
        }
        
        for item in items {
            if let cseImages = item.pagemap?.cseImage, let firstCseImage = cseImages.first, let imageUrl = firstCseImage.src {
                print("Found cseImage URL: \(imageUrl)")
                return imageUrl
            }
            if let link = item.link {
                print("Found fallback link URL: \(link)")
                return link
            }
        }
        
        print("JSON Error: No suitable image URL found")
        //throw GoogleAPIError.jsonError
        return nil
    }
}

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
}

struct CSEImage: Codable {
    let src: String?
}


