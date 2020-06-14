//
//  MapDelegate.swift
//  ParisNature
//
//  Created by co5ta on 08/06/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//

import UIKit
import MapKit

/// Delegate of the map view
class MapDelegate: NSObject {
    
    /// Mapview controller
    weak var mapVC: MapViewController?
    /// Region width and height
    let regionSize: Double = 1500
    /// True if the map must keeps the user location in center
    var isFollowing = true
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
                self.handleError(error)
            case .success(let data):
                self.handleResult(data)
            }
        }
    }
    
    /// Sets a area zone in which the search must be limited
    private func getAreaLimit(for placeType: PlaceType) -> [String] {
        guard placeType.limitedAround else { return [] }
        guard let coordinate = mapVC?.locationManager.location?.coordinate else { return [] }
        return ["\(coordinate.latitude)", "\(coordinate.longitude)", "\(regionSize/2)"]
    }
    
    /// Handles the error from the request
    private func handleError(_ error: NetworkError) {
        self.mapVC?.state = .message(error)
    }
    
    /// Handles the result of the request
    private func handleResult<T>(_ data: T) {
        switch data {
        case is GreenSpacesResult:
            if let data = data as? GreenSpacesResult { addPlaces(data.list) }
        case is EventsResult:
            if let data = data as? EventsResult { addPlaces(data.list) }
        default:
            break
        }
    }
    
    /// Adds places in the map and the table view
    private func addPlaces(_ places: [Place]) {
        guard let mapVC = mapVC else { return }
        if places.isEmpty {
            mapVC.state = .message(.emptyData)
            return
        }
        
        for place in places {
            guard place.coordinate.latitude != 0 else { continue }
            mapVC.mapView.addAnnotation(place)
            mapVC.listVC.places.append(place)
            guard let greenspace = place as? GreenSpace, let polygon = greenspace.geom.shapes else { continue }
            mapVC.mapView.addOverlay(polygon)
        }
        mapVC.mapView.showAnnotations(mapVC.mapView.annotations, animated: true)
        mapVC.state = .placesList
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
    
    /// Centers user location on the map
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        guard isFollowing else { return }
        let region = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: regionSize, longitudinalMeters: regionSize)
        mapVC?.mapView.setRegion(region, animated: true)
    }
}
