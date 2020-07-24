//
//  LocationManagerDelegate.swift
//  ParisEnFamille
//
//  Created by co5ta on 12/06/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//

import UIKit
import CoreLocation

class LocationDelegate: NSObject {

    /// Mapview controller
    weak var mapVC: MapViewController? {
        didSet { checkLocationServices() }
    }
}

// MARK: - User location
extension LocationDelegate {
    
    /// Checks if the location services are enabled
    func checkLocationServices() {
        guard let mapVC = mapVC else { return }
        if CLLocationManager.locationServicesEnabled() {
            mapVC.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            checkLocationAuthorization()
        } else {
            let alert = UIAlertController.settingsAlert(title: Strings.locationDisabled.title,
                                                      message: Strings.locationDisabled.message)
            mapVC.present(alert, animated: true)
        }
    }
    
    /// Checks the location permissions
    func checkLocationAuthorization() {
        guard let mapVC = mapVC else { return }
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse, .authorizedAlways:
            mapVC.mapView.showsUserLocation = true
        case .notDetermined:
            mapVC.locationManager.requestWhenInUseAuthorization()
        case .denied:
            let alert = UIAlertController.settingsAlert(title: Strings.locationDenied.title,
                                                      message: Strings.locationDenied.message)
            mapVC.present(alert, animated: true)
        case .restricted:
            fallthrough
        @unknown default:
            let alert = UIAlertController.settingsAlert(title: Strings.locationUnavailable.title,
                                                      message: Strings.locationUnavailable.message)
            mapVC.present(alert, animated: true)
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationDelegate: CLLocationManagerDelegate {
    
    /// Tells the delegate its authorization status when the app creates the location manager and when the authorization status changes
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}
