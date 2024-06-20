//
//  GoogleImageManager.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 1/17/24.
//

import SwiftUI
import UIKit

enum GoogleAPIError: Error {
    case serverError, urlError, jsonError, responseError
}

class GoolgeImageService {
    static let shared = GoolgeImageService()
    
    private init() {}
    
    func fetchImageUrl(for searchTerm: String) async throws -> String? {
        let endpoint = "https://www.googleapis.com/customsearch/v1?key=\("AIzaSyCtwfhw-m5veLfJMNLYi0Vdna-E0kD6qfA")&cx=\("84d755fd86d324926")&q=\(searchTerm)"
        
        guard let url = URL(string: endpoint) else {
            throw GoogleAPIError.urlError
        }
        
        let (data, response ) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            print(response)
            throw GoogleAPIError.serverError
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        guard let searchResult = try? decoder.decode(GoogleSearchResponse.self, from: data) else {
            throw GoogleAPIError.responseError
        }
        
        return try parseJSON(decodedData: searchResult)
    }
    
    private func parseJSON(decodedData: GoogleSearchResponse) throws -> String? {
        if let items = decodedData.items {
            for item in items {
                if let cseImages = item.pagemap?.cseImage {
                    for cseImage in cseImages {
                        if let imageUrl = cseImage.src {
                            return imageUrl
                        }
                    }
                }
            }
        }
        throw GoogleAPIError.jsonError
    }
}
