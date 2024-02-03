//
//  LocationDetailView-ViewModel.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 1/10/24.
//

import SwiftUI
import MapKit
import CoreImage
import CoreImage.CIFilterBuiltins

extension LocationDetailView{
    
    @Observable
    class ViewModel {
        
        // some citys do not have look around support
        var lookAroundPlace: MKLookAroundScene?
        
        var proccessedImage: UIImage?
        
        func loadAndProccessImage(url: String) async {
            
            guard let url = URL(string: url) else {
                return
            }
            
            do{
                let (data, _) = try await URLSession.shared.data(from: url)
                
                guard let uiImage = UIImage(data: data) else {
                    return
                }
                
                proccessedImage = applyDarkGrainyFilter(to: uiImage)
                
            } catch {
                print("unable to load image from \(url)")
            }
            
        }
        
        func applyDarkGrainyFilter(to inputImage: UIImage) -> UIImage? {
            let context = CIContext()
            guard let cgImage = inputImage.cgImage else { return nil }
            let ciImage = CIImage(cgImage: cgImage)

            // Apply a darkening filter
            let darkenFilter = CIFilter.colorControls()
            darkenFilter.inputImage = ciImage
            darkenFilter.brightness = -0.15 // Adjust these values as needed
            darkenFilter.contrast = 1.1

            // Apply a grain effect
            let grainFilter = CIFilter.noiseReduction()
            grainFilter.inputImage = darkenFilter.outputImage
            grainFilter.noiseLevel = 0.02 // Adjust for more or less grain
            grainFilter.sharpness = 0.7

            if let outputImage = grainFilter.outputImage,
               let cgOutputImage = context.createCGImage(outputImage, from: ciImage.extent) {
                return UIImage(cgImage: cgOutputImage)
            } else {
                return nil
            }
        }
        
        var savedLocations = [HauntedLocation]() {
            didSet {
                let url = URL.documentsDirectory.appending(component: "savedLocations")
                let encoder = JSONEncoder()
                
                let data = try? encoder.encode(savedLocations)
                
                do {
                    try data?.write(to: url)
                    
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        
        // check if some location is already in array
        func isInFavorites(location: HauntedLocation) -> Bool {
            for index in savedLocations {
                if index.coordinates == location.coordinates{
                    return true
                }
            }
            return false
        }
        
        // gets the look around preview for some cordinate if it exists
        func fetchLookAroundPreview(for locationCoordinates: CLLocationCoordinate2D) {
            Task {
                let request = MKLookAroundSceneRequest(coordinate: locationCoordinates)
                lookAroundPlace = try? await request.scene
            }
        }
    }
}
