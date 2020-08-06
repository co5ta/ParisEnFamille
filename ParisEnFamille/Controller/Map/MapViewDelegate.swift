//
//  MapViewDelegate.swift
//  ParisEnFamille
//
//  Created by co5ta on 08/06/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//

import UIKit
import MapKit

/// Delegate of the map view
class MapViewDelegate: NSObject {
    
    /// Mapview controller
    weak var mapVC: MapViewController?
    /// Region width and height
    let regionSize: Double = 1500
    /// True if the map must keeps the user location in center
    var isFollowing = true
}

// MARK: - Data
extension MapViewDelegate {
    
    /// Asks  to receive green areas
    func getPlaces<T>(placeType: PlaceType, dataType: T.Type) where T: Decodable {
        mapVC?.state = .loading
        NetworkService.shared.getPlaces(placeType: placeType, dataType: dataType.self) { [self] (result) in
            switch result {
            case .failure(let error):
                self.handleError(error)
            case .success(let data):
                self.handleResult(data)
            }
        }
    }
    
    /// Handles the error from the request
    private func handleError(_ error: NetworkError) {
        self.mapVC?.state = .message(error)
    }
    
    /// Handles the result of the request
    private func handleResult<T>(_ data: T) {
        switch data {
        case is GreenSpacesResult:
            if let data = data as? GreenSpacesResult { display(data.records) }
        case is EventsResult:
            if let data = data as? EventsResult { display(data.records) }
        default:
            print(#function, "The data type is not configured")
        }
    }
    
    /// Adds places in the map and the table view
    private func display(_ list: [Place]) {
        if list.isEmpty {
            mapVC?.state = .message(.noResult)
        } else {
            let places = filter(list)
            add(places)
            zoomIn(on: places)
            mapVC?.state = .placesList
        }
    }
    
    /// Filters the places which can be display
    private func filter(_ places: [Place]) -> [Place] {
        return places.filter {
            $0.coordinate.latitude != 0 && Config.departments.contains($0.department) && $0.isInTimeInterval
        }.reversed()
    }
    
    /// Adds the places in the map and the table view
    private func add(_ places: [Place]) {
        mapVC?.places = places
        for place in places {
            mapVC?.mapView.addAnnotation(place)
            guard let greenspace = place as? GreenSpace, let polygon = greenspace.geom.shapes else { continue }
            mapVC?.mapView.addOverlay(polygon)
        }
    }
    
    /// Zooms in on the places displayed on the map
    func zoomIn(on places: [Place]) {
        var mapRect = MKMapRect.null
        places.forEach { mapRect = mapRect.union(MKMapRect(origin: MKMapPoint($0.coordinate), size: MKMapSize(width: 1, height: 1))) }
        let edgeInsets = UIEdgeInsets(top: 30, left: 30, bottom: Config.screenSize.height * 0.4, right: 30)
        mapVC?.mapView.setVisibleMapRect(mapRect, edgePadding: edgeInsets, animated: true)
    }
}

// MARK: - MKMapViewDelegate
extension MapViewDelegate: MKMapViewDelegate {

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
        renderer.alpha = 0.5
        renderer.fillColor = .systemRed
        renderer.strokeColor = .systemRed
        return renderer
    }
    
    /// Centers user location on the map
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        guard isFollowing else { return }
        let region = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: regionSize, longitudinalMeters: regionSize)
        mapVC?.mapView.setRegion(region, animated: true)
    }
    
    /// Tells the delegate that one of its annotation views was selected.
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let mapVC = mapVC else { return }
        if let cluster = view.annotation as? MKClusterAnnotation,
            let places = cluster.memberAnnotations as? [Place] {
            let annotations = mapVC.places.filter { (place) -> Bool in
                places.contains { $0 === place } == false
            }
            mapView.removeAnnotations(annotations)
            mapVC.state = .cluster(places)
            mapVC.listVC.listView.clusterTitleLabel.text = "\(places.count) \(Strings.places)"
            mapVC.listVC.listView.cancelButton.isHidden = false
            mapVC.listVC.listView.collectionView.isHidden = true
            mapVC.listVC.listView.subTypeCollectionView.isHidden = true
        } else if let place = view.annotation as? Place {
            let annotations = mapView.annotations.filter { $0 !== place }
            mapView.removeAnnotations(annotations)
            mapVC.state = .placeDetail(place)
        }
    }
    
    /// Tells the delegate that one of its annotation views was deselected.
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        guard let mapVC = mapVC else { return }
        if let cluster = view.annotation as? MKClusterAnnotation,
            let places = cluster.memberAnnotations as? [Place] {
            let annotations = mapVC.places.filter { (place) -> Bool in
                places.contains { $0 === place } == false
            }
            mapView.addAnnotations(annotations)
            mapVC.listVC.places = mapVC.places
            mapVC.listVC.listView.clusterTitleLabel.text = ""
            mapVC.listVC.listView.cancelButton.isHidden = true
            mapVC.listVC.listView.collectionView.isHidden = false
            mapVC.listVC.listView.subTypeCollectionView.isHidden = false
        } else if let place = view.annotation as? Place {
            let annotations = mapVC.places.filter { $0 !== place }
            mapView.addAnnotations(annotations)
            mapVC.state = .placesList
        }
    }
}

// MARK: - Annotations selection
extension MapViewDelegate {
    
    /// Selects a place on the map without touching it
    func selectAnnotation(_ place: Place?) {
        guard let place = place, let mapView = mapVC?.mapView else { return }
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(place)
        mapView.setCenter(place.coordinate, animated: true)
        mapView.selectAnnotation(place, animated: true)
    }
}
