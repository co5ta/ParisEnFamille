//
//  MapViewController.swift
//  ParisNature
//
//  Created by co5ta on 09/05/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//

import UIKit
import MapKit
import FloatingPanel

/// View controller of the map 
class MapViewController: UIViewController {
    
    /// Map view
    let mapView = MKMapView()
    /// Location manager
    let locationManager = CLLocationManager()
    /// Floating panel which contains the list of places
    let listPanel = FloatingPanelController()
    /// Floating panel which contains the detail of a place
    let detailPanel = FloatingPanelController()
    /// View controller with the list of places
    let listVC = ListViewController()
    /// View controller whith the deail of a place
    let detailVC = DetailViewController()
    /// Map view delegate
    // swiftlint:disable weak_delegate
    let mapViewDelegate = MapViewDelegate()
    /// Location manager delegate
    // swiftlint:disable weak_delegate
    let locationDelegate = LocationDelegate()
    /// Floating panels delegate
    // swiftlint:disable weak_delegate
    let panelDelegate = PanelDelegate()
    /// View controller state
    var state = State.neutral {
        didSet { adjustViews() }
    }
    /// List of places
    var places = [Place]() {
        didSet { listVC.places = places }
    }
}

// MARK: - Lifecycle
extension MapViewController {
    
    /// Initializes the instance
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setUpViews()
    }
    
    /// Notifies the view controller that its view was added to a view hierarchy.
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        listPanel.addPanel(toParent: self)
        detailPanel.addPanel(toParent: self)
    }
}

// MARK: - Setup
extension MapViewController {
    
    /// Sets up the instance
    private func configure() {
        navigationController?.setNavigationBarHidden(true, animated: true)
        listVC.mapVC = self
        detailVC.mapVC = self
        mapView.delegate = mapViewDelegate
        mapViewDelegate.mapVC = self
        locationManager.delegate = locationDelegate
        locationDelegate.mapVC = self
        listPanel.delegate = panelDelegate
        detailPanel.delegate = panelDelegate
        panelDelegate.mapVC = self
    }
    
    /// Sets up the views
    private func setUpViews() {
        setUpPanels()
        setUpMapView()
        constrainViews()
    }
    
    /// Sets up the floating panels
    private func setUpPanels() {
        setUpListPanel()
        setUpDetailPanel()
    }
    
    /// Sets up the list floating panel
    private func setUpListPanel() {
        listPanel.contentMode = .fitToBounds
        listPanel.surfaceView.cornerRadius = 10
        listPanel.surfaceView.backgroundColor = .clear
        listPanel.set(contentViewController: listVC)
        listPanel.track(scrollView: listVC.listView.tableView)
    }
    
    /// Sets up the detail floating panel
    private func setUpDetailPanel() {
        detailPanel.surfaceView.cornerRadius = 10
        detailPanel.surfaceView.backgroundColor = .clear
        detailPanel.set(contentViewController: detailVC)
    }
    
    /// Sets up the map view
    private func setUpMapView() {
        mapView.register(PlaceAnnotationView.self, forAnnotationViewWithReuseIdentifier: PlaceAnnotationView.identifer)
        view.addSubview(mapView)
    }
}

// MARK: - Constraints
extension MapViewController {
    
    /// Adds constraints to map view
    private func constrainViews() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
