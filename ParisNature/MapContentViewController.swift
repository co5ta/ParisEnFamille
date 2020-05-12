//
//  MapContentViewController.swift
//  ParisNature
//
//  Created by co5ta on 09/05/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//

import UIKit
import MapKit

/// View controller of the map content
class MapContentViewController: UIViewController {
    
    /// Map view
    let mapView = MKMapView()
}

// MARK: - Lifecycle
extension MapContentViewController {
    
    /// Initializes the instance
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
}

// MARK: - Setup
extension MapContentViewController {
    
    /// Sets up the instance
    private func setUp() {
        setUpDefaultProperties()
        setUpMapView()
        getGreenAreas()
    }
    
    /// Sets up defaults view controller properties
    private func setUpDefaultProperties() {
        view.backgroundColor = .yellow
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

// MARK: - Data
extension MapContentViewController {
    
    /// Asks  to receive green areas
    private func getGreenAreas() {
        NetworkService.shared.getGreenAreas { [weak self] (result) in
            switch result {
            case .failure(let error):
                print(error)
                print(error.localizedDescription)
            case .success(let greenAreasResult):
                self?.handleSuccess(greenAreasResult.list)
            }
        }
    }
    
    /// Handles data of a successful request
    private func handleSuccess(_ greenAreas: [GreenArea]) {
        print(greenAreas.count)
        greenAreas.forEach { addMark($0.address) }
    }
    
    /// Adds a mark on the map view
    private func addMark(_ address: String) {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { [weak self] (placemarks, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let location = placemarks?.first?.location {
                let annotation = MKPointAnnotation()
                annotation.title = "Test"
                annotation.coordinate = location.coordinate
                self?.mapView.addAnnotation(annotation)
            }
        }
    }
}
