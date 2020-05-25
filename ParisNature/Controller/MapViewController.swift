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
    let floatingPanelController = FloatingPanelController()
    /// Content of the floating panel
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
        floatingPanelController.addPanel(toParent: self)
    }
}

// MARK: - Setup
extension MapViewController {
    
    /// Sets up the instance
    private func configure() {
        navigationController?.setNavigationBarHidden(true, animated: true)
        placesVC.mapVC = self
        mapView.delegate = self
        locationManager.delegate = self
        floatingPanelController.delegate = self
        configureFloatingPanelController()
    }
    
    private func configureFloatingPanelController() {
        floatingPanelController.surfaceView.cornerRadius = 10
        floatingPanelController.surfaceView.grabberHandle.isHidden = true
        floatingPanelController.surfaceView.backgroundColor = .clear
        floatingPanelController.set(contentViewController: placesVC)
        floatingPanelController.track(scrollView: placesVC.tableView)
    }
    
    /// Sets up the views
    private func setUpViews() {
        setUpMapView()
        constrainMapView()
    }
    
    /// Sets up the map view
    private func setUpMapView() {
        mapView.register(PlaceAnnotationView.self, forAnnotationViewWithReuseIdentifier: PlaceAnnotationView.identifer)
        view.addSubview(mapView)
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

// MARK: - FloatingPanelControllerDelegate
extension MapViewController: FloatingPanelControllerDelegate {
    // swiftlint:disable identifier_name
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        return CustomPanelLayout()
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
            locationManager.startUpdatingLocation()
            centerMapOnUserLocation()
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
    func getPlaces<T>(placeType: PlaceType, dataType: T.Type) where T: Decodable {
        placesVC.state = .loading
        let area = getAreaLimit(for: placeType)
        NetworkService.shared.getPlaces(placeType: placeType, dataType: dataType.self, area: area) { [weak self] (result) in
            switch result {
            case .failure(let error):
                print(#function, error)
                self?.placesVC.state = .empty
            case .success(let data):
                self?.handle(data)
            }
        }
    }
    
    public func getAreaLimit(for placeType: PlaceType) -> [String] {
        switch placeType {
        case .greenery:
            guard let coordinate = locationManager.location?.coordinate else { return [] }
            return ["\(coordinate.latitude)", "\(coordinate.longitude)", "\(regionSize/2)"]
        default:
            return []
        }
    }
    
    private func handle<T>(_ data: T) {
        switch data {
        case is GreenSpacesResult:
            if let data = data as? GreenSpacesResult { add(data.list) }
        case is EventsResult:
            if let data = data as? EventsResult { add(data.list) }
        default:
            print(#function, "Can't handle this type of data")
        }
    }
    
    private func isNotNew(_ place: Place) -> Bool {
        return placesVC.places.contains { $0.title == place.title }
    }
    
    private func add(_ places: [Place]) {
        let lastPlace = places.last
        for place in places {
            if isNotNew(place) { continue }
            CLGeocoder().geocodeAddressString(place.address) { [self] (placemarks, error) in
                guard let location = placemarks?.first?.location else {
                    if let error = error { print(#function, error.localizedDescription)}
                    return
                }
                place.coordinate = location.coordinate
                self.placesVC.places.append(place)
                self.mapView.addAnnotation(place)
                if place.title == lastPlace?.title { self.showResult() }
            }
        }
    }
    
    private func showResult() {
        mapView.showAnnotations(mapView.annotations, animated: true)
        placesVC.state = .ready
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? Place else { return nil }
        return PlaceAnnotationView(annotation: annotation, reuseIdentifier: PlaceAnnotationView.identifer)
    }
}
