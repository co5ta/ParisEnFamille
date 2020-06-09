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
    /// Floating panel which contains the list of places
    let listPanel = FloatingPanelController()
    /// Floating panel which contains the detail of a place
    let detailPanel = FloatingPanelController()
    /// View controller with the list of places
    let listVC = ListViewController()
    /// View controller whith the deail of a place
    let detailVC = DetailViewController()
    /// View controller state
    var state = State.neutral { didSet {adjustViews()} }
    /// Map view delegate
    // swiftlint:disable weak_delegate
    let mapDelegate = MapDelegate()
    /// Floating panels delegate
    // swiftlint:disable weak_delegate
    let panelDelegate = PanelDelegate()
}

// MARK: - Lifecycle
extension MapViewController {
    
    /// Initializes the instance
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setUpViews()
        mapDelegate.checkLocationServices()
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
        mapView.delegate = mapDelegate
        mapDelegate.mapVC = self
        listPanel.delegate = panelDelegate
        detailPanel.delegate = panelDelegate
        panelDelegate.mapVC = self
        listVC.mapVC = self
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
        listPanel.track(scrollView: listVC.tableView)
    }
    
    /// Sets up the detail floating panel
    private func setUpDetailPanel() {
        detailPanel.surfaceView.cornerRadius = 10
        detailPanel.surfaceView.backgroundColor = .clear
        detailPanel.set(contentViewController: detailVC)
        detailPanel.track(scrollView: detailVC.scrollView)
    }
    
    /// Sets up the map view
    private func setUpMapView() {
        mapView.register(PlaceAnnotationView.self, forAnnotationViewWithReuseIdentifier: PlaceAnnotationView.identifer)
        view.addSubview(mapView)
    }
}

// MARK: - Actions
extension MapViewController {
    
    /// Closes the
    @objc
    func cancelButtonTapped() {
        displayPlacesList()
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
            break
        case .loading:
            displayLoading()
        case .placesList:
            displayPlacesList()
        case .placeDetail(let place):
            displayPlaceDetail(place: place)
        case .empty:
            displayError()
        }
    }
    
    /// Displays loading
    private func displayLoading() {
        listPanel.move(to: .half, animated: true)
        listVC.loadingView.startAnimating()
        listVC.tableView.isHidden = true
    }
    
    /// Displays the list of places
    private func displayPlacesList() {
        listVC.loadingView.stopAnimating()
        listVC.tableView.isHidden = false
        detailPanel.move(to: .hidden, animated: true)
        let position = (panelDelegate.lastPanelPosition == nil) ? .half : panelDelegate.lastPanelPosition!
        listPanel.move(to: position, animated: true)
    }
    
    /// Displays the detail of a place
    private func displayPlaceDetail(place: Place?) {
        panelDelegate.lastPanelPosition = listPanel.position
        listPanel.move(to: .hidden, animated: true)
        detailPanel.move(to: .half, animated: true)
        detailVC.place = place
    }
    
    /// Displays error message
    private func displayError() {
        listPanel.move(to: .half, animated: true)
        listVC.loadingView.stopAnimating()
        listVC.tableView.isHidden = true
    }
}
