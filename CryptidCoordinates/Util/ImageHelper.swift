//
//  ImageHelper.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 7/11/24.
//

import CoreImage
import Kingfisher
import SwiftUI

@Observable
class ImageHelper {
    var image: UIImage?
    
    func loadImage(url: URL?) {
        guard let url = url else { return }
        
        KingfisherManager.shared.retrieveImage(with: url) { result in
            switch result {
            case .success(let value):
                self.image = ImageHelper.applyHauntedFilter(to: value.image)
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    static func applyHauntedFilter(to inputImage: UIImage) -> UIImage? {
        let context = CIContext(options: nil)
        guard let cgImage = inputImage.cgImage else { return nil }
        let ciImage = CIImage(cgImage: cgImage)
        
        // Desaturate the image more heavily
        guard let desaturateFilter = CIFilter(name: "CIColorControls") else { return nil }
        desaturateFilter.setValue(ciImage, forKey: kCIInputImageKey)
        desaturateFilter.setValue(0.4, forKey: kCIInputSaturationKey)
        desaturateFilter.setValue(-0.1, forKey: kCIInputBrightnessKey)
        desaturateFilter.setValue(1.2, forKey: kCIInputContrastKey)
        
        // Apply a vignette
        guard let vignetteFilter = CIFilter(name: "CIVignette") else { return nil }
        vignetteFilter.setValue(desaturateFilter.outputImage, forKey: kCIInputImageKey)
        vignetteFilter.setValue(1.0, forKey: kCIInputIntensityKey)
        vignetteFilter.setValue(2.0, forKey: kCIInputRadiusKey)
        
        // Add a sepia tone
        guard let sepiaFilter = CIFilter(name: "CISepiaTone") else { return nil }
        sepiaFilter.setValue(vignetteFilter.outputImage, forKey: kCIInputImageKey)
        sepiaFilter.setValue(0.8, forKey: kCIInputIntensityKey)
        
        // Add noise
        guard let noiseFilter = CIFilter(name: "CINoiseReduction") else { return nil }
        noiseFilter.setValue(sepiaFilter.outputImage, forKey: kCIInputImageKey)
        noiseFilter.setValue(0.02, forKey: "inputNoiseLevel")
        noiseFilter.setValue(0.4, forKey: "inputSharpness")
        
        // Apply a slight green tint
        guard let tintFilter = CIFilter(name: "CIColorMonochrome") else { return nil }
        tintFilter.setValue(noiseFilter.outputImage, forKey: kCIInputImageKey)
        tintFilter.setValue(CIColor(color: UIColor(red: 0.7, green: 0.8, blue: 0.6, alpha: 1.0)), forKey: kCIInputColorKey)
        tintFilter.setValue(0.3, forKey: kCIInputIntensityKey)
        
        if let outputImage = tintFilter.outputImage,
           let cgOutputImage = context.createCGImage(outputImage, from: ciImage.extent) {
            return UIImage(cgImage: cgOutputImage)
        } else {
            return nil
        }
    }
}
