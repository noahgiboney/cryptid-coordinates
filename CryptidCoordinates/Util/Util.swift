//
//  Util.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 7/7/24.
//

import CoreLocation
import UIKit

func roundToTenth(_ number: Double) -> String {
    let roundedNumber = (number * 10).rounded() / 10
    let formatter = NumberFormatter()
    formatter.minimumFractionDigits = 0
    formatter.maximumFractionDigits = 1
    formatter.numberStyle = .decimal
    return formatter.string(from: NSNumber(value: roundedNumber)) ?? "\(roundedNumber)"
}

extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}

extension CLLocationCoordinate2D {
    func distance(from location: CLLocation) -> CLLocationDistance {
        let selfLocation = CLLocation(latitude: self.latitude, longitude: self.longitude)
        return selfLocation.distance(from: location)
    }
}
