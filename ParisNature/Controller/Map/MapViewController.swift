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
    let mapDelegate = MapDelegate()
    /// Location manager delegate
    // swiftlint:disable weak_delegate
    let locationManagerDelegate = LocationManagerDelegate()
    /// Floating panels delegate
    // swiftlint:disable weak_delegate
    let panelDelegate = PanelDelegate()
    /// View controller state
    var state = State.neutral {
        didSet { adjustViews() }
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
        mapView.delegate = mapDelegate
        mapDelegate.mapVC = self
        locationManager.delegate = locationManagerDelegate
        locationManagerDelegate.mapVC = self
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
        detailPanel.track(scrollView: detailVC.detailView.scrollView)
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

// MARK: - State
extension MapViewController {
    
    /// Adjusts the views according to view controller state
    private func adjustViews() {
        switch state {
        case .neutral:
            initDisplay()
        case .loading:
            displayLoading()
        case .placesList(let error):
            displayPlacesList(error)
        case .placeDetail(let place):
            displayDetail(of: place)
        }
    }
    
    private func initDisplay() {
//        toggleViews(show: listVC.listView.errorView)
    }
    
    /// Displays loading
    private func displayLoading() {
        mapDelegate.isFollowing = false
        toggleViews(show: listVC.listView.loadingView)
        listPanel.move(to: .half, animated: true)
    }
    
    /// Displays the list of places
    private func displayPlacesList(_ error: NetworkError?) {
        if let error = error {
            listVC.listView.errorView.error = error
            toggleViews(show: listVC.listView.errorView)
            listPanel.move(to: .full, animated: true)
        } else {
            let position = panelDelegate.lastPanelPosition ?? .half
            toggleViews(show: listVC.listView.tableView)
            listPanel.move(to: position, animated: true)
        }
        detailPanel.move(to: .hidden, animated: true)
    }
    
    /// Displays the detail of a place
    private func displayDetail(of place: Place?) {
        detailVC.place = place
        panelDelegate.lastPanelPosition = listPanel.position
        listPanel.move(to: .hidden, animated: true)
        detailPanel.move(to: .half, animated: true)
    }
    
    /// Toggles the views of the list view controller
    private func toggleViews(show view: UIView) {
        [listVC.listView.loadingView, listVC.listView.tableView, listVC.listView.errorView].forEach {
            $0.isHidden = ($0 == view) ? false : true
        }
    }
}
