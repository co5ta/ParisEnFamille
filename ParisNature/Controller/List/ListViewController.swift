//
//  PlacesViewController.swift
//  ParisNature
//
//  Created by co5ta on 16/05/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//

import UIKit

/// Manages the display of list of places
class ListViewController: UIViewController {
    
    /// Map view controller
    weak var mapVC: MapViewController?
    /// List of places
    let listView = ListView()
    // swiftlint:disable weak_delegate
    let tableViewDelegate = TableViewDelegate()
    // swiftlint:disable weak_delegate
    let collectionViewDelegate = CollectionViewDelegate()
    // swiftlint:disable weak_delegate
    let subTypeCollectionViewDelegate = SubTypeCollectionViewDelegate()
    /// Place type selected
    var placeType: PlaceType? {
        didSet { subTypeCollectionViewDelegate.update() }
    }
    /// Subtype place selected
    var placeSubtype: PlaceType?
    /// List of places founded by the research
    var places = [Place]() {
        didSet { listView.tableView.reloadData() }
    }
}

// MARK: - Lifecycle
extension ListViewController {
    
    /// Called after the controller's view is loaded into memory
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        configure()
    }
}

// MARK: - Setup
extension ListViewController {
    
    /// Configures the view controller
    private func configure() {
        listView.collectionView.dataSource = collectionViewDelegate
        listView.collectionView.delegate = collectionViewDelegate
        collectionViewDelegate.listVC = self
//        listView.subTypeCollectionView.dataSource = subTypeCollectionViewDelegate
//        listView.subTypeCollectionView.delegate = subTypeCollectionViewDelegate
//        subTypeCollectionViewDelegate.listVC = self
        listView.tableView.dataSource = tableViewDelegate
        listView.tableView.delegate = tableViewDelegate
        tableViewDelegate.listVC = self
    }
    
    /// Sets up the views
    private func setUpViews() {
        listView.cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        view.addSubview(listView)
        constrainViews()
    }
    
    /// Deselects a cluster
    @objc
    private func cancelButtonTapped() {
        guard let mapView = mapVC?.mapView else { return }
        mapView.selectedAnnotations.forEach {
            mapView.deselectAnnotation($0, animated: true)
        }
    }
    
    func getPlaces(placeType: PlaceType) {
        switch placeType {
        case .park, .garden, .promenade:
            mapVC?.mapDelegate.getPlaces(placeType: placeType, dataType: GreenSpacesResult.self)
        default:
            mapVC?.mapDelegate.getPlaces(placeType: placeType, dataType: EventsResult.self)
        }
    }
    
    /// Removes the places frome the previous search
    func removePlaces() {
        places.removeAll()
        listView.tableView.reloadData()
        guard let mapVC = mapVC else { return }
        mapVC.mapView.removeAnnotations(mapVC.mapView.annotations)
        mapVC.mapView.removeOverlays(mapVC.mapView.overlays)
    }
}

// MARK: - Constraints
extension ListViewController {
    
    /// Constrains  views
    private func constrainViews() {
        listView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            listView.topAnchor.constraint(equalTo: view.topAnchor),
            listView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            listView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            listView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
