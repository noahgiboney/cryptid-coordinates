//
//  BundleDecode.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 1/9/24.
//

import Foundation

extension Bundle {
    func decode(file: String) -> [Locat] {
        
        //ensure json file is in the bundle
        guard let url = self.url(forResource: file, withExtension: nil) else{
            fatalError("Cannot find \(file) in app bundle")
        }
        
        //load the data
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Cannot load data from \(file)")
        }
        
        //decode data from json and return arr
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let decodedLocations = try? decoder.decode([OldLocation].self, from: data) else{
            fatalError("Unable to decode json from \(file)")
        }
        return decodedLocations
    }
    
    func newDecode(file: String) -> [Location] {
        
        //ensure json file is in the bundle
        guard let url = self.url(forResource: file, withExtension: nil) else{
            fatalError("Cannot find \(file) in app bundle")
        }
        
        //load the data
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Cannot load data from \(file)")
        }
        
        //decode data from json and return arr
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let decodedLocations = try? decoder.decode([Location].self, from: data) else{
            fatalError("Unable to decode json from \(file)")
        }
        return decodedLocations
    }
}
