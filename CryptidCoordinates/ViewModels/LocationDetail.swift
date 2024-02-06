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
        
        // processed image
        var proccessedImage: UIImage?
        
        func openInMaps(location: HauntedLocation) {
            let item = MKMapItem(placemark: MKPlacemark(coordinate: location.coordinates))
            item.openInMaps()
        }
        
        // load and apply filter to an image form url
        func loadAndProccessImage(url: String) async {
            
            guard let url = URL(string: url) else {
                return
            }
            
            do{
                let (data, _) = try await URLSession.shared.data(from: url)
                
                guard let uiImage = UIImage(data: data) else {
                    return
                }
                
                proccessedImage = applyHuantedFilter(to: uiImage)
                
            } catch {
                print("unable to load image from \(url)")
            }
            
        }
        
        // apply filter to a UIImage
        func applyHuantedFilter(to inputImage: UIImage) -> UIImage? {
            let context = CIContext(options: nil)
            guard let cgImage = inputImage.cgImage else { return nil }
            let ciImage = CIImage(cgImage: cgImage)

            // Apply a darkening filter to reduce brightness and increase contrast
            guard let darkenFilter = CIFilter(name: "CIColorControls") else { return nil }
            darkenFilter.setValue(ciImage, forKey: kCIInputImageKey)
            darkenFilter.setValue(-0.2, forKey: kCIInputBrightnessKey)
            darkenFilter.setValue(1.2, forKey: kCIInputContrastKey)

            // Apply a vignette effect to darken the edges, enhancing the haunted look
            guard let vignetteFilter = CIFilter(name: "CIVignette") else { return nil }
            vignetteFilter.setValue(darkenFilter.outputImage, forKey: kCIInputImageKey)
            vignetteFilter.setValue(2, forKey: kCIInputIntensityKey)
            vignetteFilter.setValue(1, forKey: kCIInputRadiusKey)

            // Apply a grain effect to introduce noise
            guard let grainFilter = CIFilter(name: "CINoiseReduction") else { return nil }
            grainFilter.setValue(vignetteFilter.outputImage, forKey: kCIInputImageKey)
            grainFilter.setValue(0.05, forKey: "inputNoiseLevel")
            grainFilter.setValue(0.7, forKey: "inputSharpness")

            // Optional: Apply a color monochrome filter to give a chilling color tint
            guard let colorMonochromeFilter = CIFilter(name: "CIColorMonochrome") else { return nil }
            colorMonochromeFilter.setValue(grainFilter.outputImage, forKey: kCIInputImageKey)
            colorMonochromeFilter.setValue(CIColor(color: UIColor(white: 0.5, alpha: 1.0)), forKey: kCIInputColorKey)
            colorMonochromeFilter.setValue(0.1, forKey: kCIInputIntensityKey)

            if let outputImage = colorMonochromeFilter.outputImage,
               let cgOutputImage = context.createCGImage(outputImage, from: ciImage.extent) {
                return UIImage(cgImage: cgOutputImage)
            } else {
                return nil
            }
        }
        
        // array of locations to store in app storage
        var savedLocations = [HauntedLocation]() {
            didSet {
                let url = URL.documentsDirectory.appending(component: "savedLocations")
                let data = try? JSONEncoder().encode(savedLocations)
                do {
                    try data?.write(to: url)
                    
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        
        // append or remove location from favorites by pressing star
        func toggleStar(location: HauntedLocation) {
            if !isInFavorites(location: location) {
                savedLocations.append(location)
            }
            else {
                if let index = savedLocations.firstIndex(of: location) {
                    savedLocations.remove(at: index)
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
        
        // load saved locations from app storage
        func loadSavedLoations() {
            let url = URL.documentsDirectory.appending(component: "savedLocations")
            
            guard let data = try? Data(contentsOf: url) else {
                return
            }
            
            do {
                savedLocations = try JSONDecoder().decode([HauntedLocation].self, from: data)
            } catch {
                print(error.localizedDescription)
            }
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
