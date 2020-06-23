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
        
        var list = [Place]()
        for place in places {
            guard place.coordinate.latitude != 0 else { continue }
            list.append(place)
            mapVC.mapView.addAnnotation(place)
            guard let greenspace = place as? GreenSpace, let polygon = greenspace.geom.shapes else { continue }
            mapVC.mapView.addOverlay(polygon)
        }
        mapVC.places = list
        mapVC.state = .placesList
        mapVC.mapView.showAnnotations(mapVC.mapView.annotations, animated: true)
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
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let mapVC = mapVC else { return }
        if let cluster = view.annotation as? MKClusterAnnotation,
            let places = cluster.memberAnnotations as? [Place] {
            let annotations = mapVC.places.filter { (place) -> Bool in
                places.contains { $0 === place } == false
            }
            mapView.removeAnnotations(annotations)
            mapVC.state = .cluster(places)

            let title = places.count > 1 ? "places" : "place"
            mapVC.listVC.listView.clusterTitleLabel.text = "\(places.count) \(title)"
            mapVC.listVC.listView.cancelButton.isHidden = false
            mapVC.listVC.listView.collectionView.isHidden = true
        } else if let place = view.annotation as? Place {
            let annotations = mapView.annotations.filter { $0 !== place }
            mapView.removeAnnotations(annotations)
            mapVC.state = .placeDetail(place)
        }
    }
    
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
        } else if let place = view.annotation as? Place {
            let annotations = mapVC.places.filter { $0 !== place }
            mapView.addAnnotations(annotations)
            mapVC.state = .placesList
        }
    }
}

// MARK: - Annotations selection
extension MapDelegate {
    
    private func getCluster(annotation: MKAnnotation) -> [MKClusterAnnotation]? {
        guard let clusters = mapVC?.mapView.annotations.filter({ $0 is MKClusterAnnotation }) as? [MKClusterAnnotation]
            else { return nil }
        var result = [MKClusterAnnotation]()
        for cluster in clusters {
            if (cluster.memberAnnotations.first(where: { $0 === annotation }) != nil) {
                result.append(cluster)
            }
        }
        print(#function, result.count)
        return result.isEmpty ? nil : result
    }
    
    private func getAnnotation(from place: Place) -> MKAnnotation? {
        let annotation = mapVC?.mapView.annotations.first(where: { $0.title == place.title })
        return annotation
    }
    
    func selectAnnotation(of place: Place?) {
        guard let place = place, let mapView = mapVC?.mapView else { return }
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(place)
        mapView.setCenter(place.coordinate, animated: true)
        mapView.selectAnnotation(place, animated: true)
    }
}
