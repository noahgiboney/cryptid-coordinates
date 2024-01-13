//
//  LocationDetailView-ViewModel.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 1/10/24.
//

import Foundation

extension LocationDetailView{
    
    @Observable
    class ViewModel {
        
        private(set) var queryURL: String = ""
        
        func getImage(searchTerm: String) async throws{
            // establish url endpoint
            
            let endpoint = "https://www.googleapis.com/customsearch/v1?key=\("")&cx=\("")&q=\(searchTerm)"
            
            guard let url = URL(string: endpoint) else {
                throw APIError.urlError
            }
            
            // grab data from urlsession
            let (data, response ) = try await URLSession.shared.data(from: url)
            
            // valid good response
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                throw APIError.serverError
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            if let searchResult = try? decoder.decode(GoogleSearchResponse.self, from: data) {
                try parseJSON(decodedData: searchResult)
            }
        }
        
        func parseJSON(decodedData: GoogleSearchResponse) throws {
            if let items = decodedData.items {
                for item in items {
                    if let cseImages = item.pagemap?.cseImage {
                        for cseImage in cseImages {
                            if let imageURL = cseImage.src {
                                queryURL = imageURL
                                return
                            }
                            throw APIError.jsonError
                        }
                    }
                }
            }
        }
    }
}
