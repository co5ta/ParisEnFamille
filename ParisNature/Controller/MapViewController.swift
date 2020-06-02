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
    /// Floating panel which contains the list of places
    let listPanelController = FloatingPanelController()
    /// View controller with the list of places
    let placesListVC = ListViewController()
    /// Floating panel which contains the detail of a place
    let detailPanelController = FloatingPanelController()
    /// View controller whith the deail of a place
    let placeDetailVC = DetailViewController()
}

// MARK: - Lifecycle
extension MapViewController {
    
    /// Initializes the instance
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setUpPanels()
        setUpViews()
        checkLocationServices()
    }
    
    /// Notifies the view controller that its view was added to a view hierarchy.
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        listPanelController.addPanel(toParent: self)
        detailPanelController.addPanel(toParent: self)
    }
}

// MARK: - Setup
extension MapViewController {
    
    /// Sets up the instance
    private func configure() {
        navigationController?.setNavigationBarHidden(true, animated: true)
        placesListVC.mapVC = self
        mapView.delegate = self
        locationManager.delegate = self
        listPanelController.delegate = self
        detailPanelController.delegate = self
    }
    
    /// Sets up the floating panels
    private func setUpPanels() {
        setUpListPanelController()
        setUpDetailPanelController()
    }
    
    /// Sets up the list floating panel
    private func setUpListPanelController() {
        listPanelController.surfaceView.cornerRadius = 10
        listPanelController.surfaceView.backgroundColor = .clear
        listPanelController.set(contentViewController: placesListVC)
        listPanelController.track(scrollView: placesListVC.tableView)
    }
    
    /// Sets up the detail floating panel
    private func setUpDetailPanelController() {
        detailPanelController.surfaceView.cornerRadius = 10
        detailPanelController.isRemovalInteractionEnabled = true
        detailPanelController.set(contentViewController: placeDetailVC)
        detailPanelController.surfaceView.backgroundColor = .clear
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
    
    /// Defines which floating panel to use
    // swiftlint:disable identifier_name
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        if vc == detailPanelController {
            return DetailPanelLayout()
        } else {
            return ListPanelLayout()
        }
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
    
    /// Checks the location permissions
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
        placesListVC.state = .loading
        let area = getAreaLimit(for: placeType)
        NetworkService.shared.getPlaces(placeType: placeType, dataType: dataType.self, area: area) { [weak self] (result) in
            switch result {
            case .failure(let error):
                print(#function, error)
                self?.placesListVC.state = .empty
            case .success(let data):
                self?.handle(data)
            }
        }
    }
    
    /// Sets a area zone in which the search must be limited
    public func getAreaLimit(for placeType: PlaceType) -> [String] {
        guard placeType.limitedAround else { return [] }
        guard let coordinate = locationManager.location?.coordinate else { return [] }
        return ["\(coordinate.latitude)", "\(coordinate.longitude)", "\(regionSize/2)"]
    }
    
    /// Handles the result of the request
    private func handle<T>(_ data: T) {
        switch data {
        case is GreenSpacesResult:
            if let data = data as? GreenSpacesResult { add(places: data.list) }
        case is EventsResult:
            if let data = data as? EventsResult { add(places: data.list) }
        default:
            print(#function, "Can't handle this type of data")
        }
    }
    
    /// Checks if the place is not already in the list
    private func isNew(_ place: Place) -> Bool {
        return placesListVC.places.contains { $0.title == place.title } == false
    }
    
    /// Adds places in the map and the table view
    private func add(places: [Place]) {
        for place in places {
            guard isNew(place), place.coordinate.latitude != 0 else { continue }
            mapView.addAnnotation(place)
            placesListVC.places.append(place)
            guard let greenspace = place as? GreenSpace, let polygon = greenspace.geom.shapes else { continue }
            mapView.addOverlay(polygon)
        }
        mapView.showAnnotations(mapView.annotations, animated: true)
        placesListVC.state = .ready
    }
}

// MARK: - MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {

    /// Returns the view associated with the specified annotation object
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? Place else { return nil }
        return PlaceAnnotationView(annotation: annotation, reuseIdentifier: PlaceAnnotationView.identifer)
    }
    
    /// Asks the delegate for a renderer object to use when drawing the specified overlay
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        print("rendering")
        guard let overlay = overlay as? MKPolygon else { return MKOverlayRenderer() }
        let renderer = MKPolygonRenderer(polygon: overlay)
        renderer.lineWidth = 2
        renderer.fillColor = .systemRed
        renderer.alpha = 0.5
        renderer.strokeColor = .systemRed
        return renderer
    }
}
