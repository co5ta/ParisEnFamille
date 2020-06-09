//
//  MapDelegate.swift
//  ParisNature
//
//  Created by co5ta on 08/06/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

/// Delegate of the map view
class MapDelegate: NSObject {
    
    /// Mapview controller
    weak var mapVC: MapViewController?
    /// Location manager
    let locationManager = CLLocationManager()
    /// Region width and height
    let regionSize: Double = 1500
    
    /// Initializes the class
    override init() {
        super.init()
        locationManager.delegate = self
    }
}

// MARK: - MKMapViewDelegate
extension MapDelegate: MKMapViewDelegate {

    /// Returns the view associated with the specified annotation object
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? Place else { return nil }
        return PlaceAnnotationView(annotation: annotation, reuseIdentifier: PlaceAnnotationView.identifer)
    }
    
    /// Asks the delegate for a renderer object to use when drawing the specified overlay
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let overlay = overlay as? MKPolygon else { return MKOverlayRenderer() }
        let renderer = MKPolygonRenderer(polygon: overlay)
        renderer.lineWidth = 2
        renderer.fillColor = .systemRed
        renderer.alpha = 0.5
        renderer.strokeColor = .systemRed
        return renderer
    }
}

// MARK: - CLLocationManagerDelegate
extension MapDelegate: CLLocationManagerDelegate {
    
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

// MARK: - Location
extension MapDelegate {
    
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
            mapVC?.mapView.showsUserLocation = true
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
        mapVC?.mapView.setRegion(region, animated: true)
    }
}

// MARK: - Data
extension MapDelegate {
    
    /// Asks  to receive green areas
    func getPlaces<T>(placeType: PlaceType, dataType: T.Type) where T: Decodable {
        mapVC?.state = .loading
        let area = getAreaLimit(for: placeType)
        NetworkService.shared.getPlaces(placeType: placeType, dataType: dataType.self, area: area) { [self] (result) in
            switch result {
            case .failure(let error):
                self.handle(error)
            case .success(let data):
                self.handle(data)
            }
        }
    }
    
    /// Sets a area zone in which the search must be limited
    private func getAreaLimit(for placeType: PlaceType) -> [String] {
        guard placeType.limitedAround else { return [] }
        guard let coordinate = locationManager.location?.coordinate else { return [] }
        return ["\(coordinate.latitude)", "\(coordinate.longitude)", "\(regionSize/2)"]
    }
    
    /// Handles the error from the request
    private func handle(_ error: NetworkError) {
        print(#function, error)
        self.mapVC?.state = .empty
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
    
    /// Adds places in the map and the table view
    private func add(places: [Place]) {
        guard let mapVC = mapVC else { return }
        for place in places {
            guard isNew(place), place.coordinate.latitude != 0 else { continue }
            place.calculateDistance(from: locationManager.location)
            mapVC.mapView.addAnnotation(place)
            mapVC.listVC.places.append(place)
            guard let greenspace = place as? GreenSpace, let polygon = greenspace.geom.shapes else { continue }
            mapVC.mapView.addOverlay(polygon)
        }
        mapVC.mapView.showAnnotations(mapVC.mapView.annotations, animated: true)
        mapVC.state = .placesList
    }
    
    /// Checks if the place is not already in the list
    private func isNew(_ place: Place) -> Bool {
        return mapVC?.listVC.places.contains { $0.title == place.title } == false
    }
}
