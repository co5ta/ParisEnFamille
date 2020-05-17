//
//  MapViewController.swift
//  ParisNature
//
//  Created by co5ta on 09/05/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import FloatingPanel

/// View controller of the map 
class MapViewController: UIViewController {
    
    /// Map view
    let mapView = MKMapView()
    /// Location manager
    let locationManager = CLLocationManager()
    /// Region width and height
    let regionSize: Double = 1500
    /// Floating panel
    let fpc = FloatingPanelController()
    /// Floating panel content
    let placesVC = PlacesViewController()
}

// MARK: - Lifecycle
extension MapViewController {
    
    /// Initializes the instance
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setUpViews()
        checkLocationServices()
    }
    
    /// Notifies the view controller that its view was added to a view hierarchy.
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fpc.addPanel(toParent: self)
    }
}

// MARK: - Setup
extension MapViewController {
    
    /// Sets up the instance
    private func configure() {
        navigationController?.setNavigationBarHidden(true, animated: true)
        locationManager.delegate = self
//        fpc.delegate = self
        fpc.set(contentViewController: placesVC)
    }
    
    /// Sets up the views
    private func setUpViews() {
        setUpMapView()
    }
    
    /// Sets up the map view
    private func setUpMapView() {
        view.addSubview(mapView)
        constrainMapView()
    }
    
    /// Adds constraints to map view
    private func constrainMapView() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - Location
extension MapViewController {
    
    /// Checks if the location services are enabled
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
             locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            checkLocationAuthorization()
        } else {
            // Ask user to enable location service
            print("Location service disabled")
        }
    }
    
    /// Checks location permissions
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse, .authorizedAlways:
            mapView.showsUserLocation = true
            centerMapOnUserLocation()
            locationManager.startUpdatingLocation()
            getGreenAreas()
        case .denied:
            // Ask user to activate authorisation
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            fallthrough
        @unknown default:
            // Explain what's going on
            break
        }
    }
    
    /// Centers the map on the user location
    func centerMapOnUserLocation() {
        guard let coordinate = locationManager.location?.coordinate else { return }
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: regionSize, longitudinalMeters: regionSize)
        mapView.setRegion(region, animated: true)
    }
}

// MARK: - CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate {
    
    /// Tells the delegate that new location data is available
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.last else { return }
//        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionSize, longitudinalMeters: regionSize)
//        mapView.setRegion(region, animated: true)
    }
    
    /// Tells the delegate its authorization status when the app creates the location manager and when the authorization status changes
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}

// MARK: - Data
extension MapViewController {
    
    /// Asks  to receive green areas
    private func getGreenAreas() {
        guard let coordinate = locationManager.location?.coordinate else { return }
        let area = ["\(coordinate.latitude)", "\(coordinate.longitude)", "\(regionSize/2)"]
        NetworkService.shared.getGreenAreas(area: area) { [weak self] (result) in
            switch result {
            case .failure(let error):
                print(error)
                print(error.localizedDescription)
            case .success(let greenAreasResult):
                print(greenAreasResult.list.count)
                greenAreasResult.list.forEach { self?.addMark($0) }
            }
        }
    }
    
    /// Adds a mark on the map view
    private func addMark(_ greenArea: GreenArea) {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(greenArea.address) { [weak self] (placemarks, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let location = placemarks?.first?.location {
                let annotation = MKPointAnnotation()
                annotation.title = greenArea.name
                annotation.coordinate = location.coordinate
                self?.mapView.addAnnotation(annotation)
            }
        }
    }
}
