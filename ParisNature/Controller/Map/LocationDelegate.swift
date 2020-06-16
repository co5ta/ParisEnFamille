//
//  LocationManagerDelegate.swift
//  ParisNature
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
        if CLLocationManager.locationServicesEnabled() {
            mapVC?.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            checkLocationAuthorization()
        } else {
            // Ask user to enable location service
            print("Location service disabled")
        }
    }
    
    /// Checks the location permissions
    func checkLocationAuthorization() {
        guard let mapVC = mapVC else { return }
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse, .authorizedAlways:
            mapVC.mapView.showsUserLocation = true
//            mapVC.mapDelegate.centerMapOnUserLocation()
//            mapVC.locationManager.startUpdatingLocation()
//            mapVC.locationManager.requestLocation()
        case .denied:
            // Ask user to activate authorisation
            break
        case .notDetermined:
            mapVC.locationManager.requestWhenInUseAuthorization()
        case .restricted:
            fallthrough
        @unknown default:
            // Explain what's going on
            break
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
