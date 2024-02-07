//
//  GoogleImageManager.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 1/17/24.
//

import SwiftUI
import UIKit

@Observable
class GoogleAPIManager {
    
    enum APIError: Error {
        case serverError, urlError, jsonError, responseError
    }
    
    var queryURL: String = ""
    
    // assigns queryURL for the image url based on search term
    func fetchURL(for searchTerm: String) async {
        do{
            try await callAPI(search: "\(searchTerm)")
            
        } catch APIError.urlError {
            print("invalid url")
        } catch APIError.jsonError {
            print("invalid json")
        } catch APIError.responseError{
            print("invalid gserver response")
        } catch APIError.serverError {
            print("invalid server response")
        } catch {
            print("error getting image")
        }
    }
    
    // performs network call to get url
    private func callAPI(search searchTerm: String) async throws{
        
        // api stuff
        let apiKey = ProcessInfo().environment["API_KEY"] ?? ""
        let searchID = ProcessInfo().environment["SEARCH_ID"] ?? ""
        
        // establish url endpoint
        let endpoint = "https://www.googleapis.com/customsearch/v1?key=\(apiKey)&cx=\(searchID)&q=\(searchTerm)"
        
        guard let url = URL(string: endpoint) else {
            throw APIError.urlError
        }
        
        // grab data from urlsession
        let (data, response ) = try await URLSession.shared.data(from: url)
        
        // valid response is 200
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            print(response)
            throw APIError.serverError
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        if let searchResult = try? decoder.decode(GoogleSearchResponse.self, from: data) {
            try parseJSON(decodedData: searchResult)
        }
    }
    
    //parse json to retrieve url
    private func parseJSON(decodedData: GoogleSearchResponse) throws {
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
