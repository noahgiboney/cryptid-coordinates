//
//  LocationDetail.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 1/9/24.
//

import SwiftUI

struct LocationDetailView: View {
    
    enum APIError: Error {
        case serverError, urlError, jsonError, responseError
    }
    
    @Environment(\.dismiss) var dismiss
    
    @State private var viewModel = ViewModel()
    @State private var imageURL: String = "No Image Found"
    
    
    var location: HauntedLocation
    
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack(alignment: .leading, spacing: 20){
                    
                    VStack(alignment: .leading, spacing: 5){
                        Text(location.name)
                            .font(.title.bold())
                        Text("\(location.city), \(location.country)")
                            .font(.subheadline.italic())
                    }
                    
                    Divider()
                    
                    Label(
                        title: { Text("Detailed Accout") },
                        icon: { Image(systemName: "doc.text.magnifyingglass") }
                    )
                    .font(.title2.weight(.medium))
                                        
                    Text(location.description)
                    
                    Divider()
                    
                }
                .padding()
            }
            .task{
                do{
                    try await getImage()
                    
                } catch APIError.urlError {
                    print("invalid url")
                } catch APIError.jsonError {
                    print("invalid json")
                } catch APIError.responseError{
                    print("invlaid server response")
                } catch {
                    print("error")
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading){
                    Button("Close") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing){
                    Button {
                        
                    } label: {
                        Text("Save")
                        Image(systemName: "square.and.arrow.down")
                    }
                }
            }
        }
    }

    func getImage() async throws{
        
        let endpoint = ""
        
        guard let url = URL(string: endpoint) else {
            throw APIError.urlError
        }
        
        let (data, response ) = try await URLSession.shared.data(from: url)
        print(String(data: data, encoding: .utf8) ?? "No data")
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw APIError.serverError
        }
            
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        if let decodedData = try? decoder.decode(GoogleSearchResponse.self, from: data) {
            if let items = decodedData.items {
                for item in items {
                    if let cseImages = item.pagemap?.cseImage {
                        for cseImage in cseImages {
                            if let imageURL = cseImage.src {
                                print(imageURL)
                                return
                            }
                        }
                    }
                }
            }
        }
        throw APIError.jsonError
    }
}

#Preview {
    LocationDetailView(location: HauntedLocation.example)
}
