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
    
    weak var mapVC: MapViewController?
    var visualEffectView: UIVisualEffectView!
    var collectionView: UICollectionView!
    var imagesButton = [UIButton]()
    let tableView = UITableView()
    var places = [Place]() { didSet {placeListDelegate.updateTableView(oldValue)} }
    var loadingView = UIActivityIndicatorView()
    var errorView = ErrorView()
    // swiftlint:disable weak_delegate
    let placeListDelegate = PlaceListDelegate()
    // swiftlint:disable weak_delegate
    let placeTypeListDelegate = PlaceTypeListDelegate()
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
        view.backgroundColor = .clear
        collectionView.dataSource = placeTypeListDelegate
        collectionView.delegate = placeTypeListDelegate
        placeTypeListDelegate.listVC = self
        tableView.dataSource = placeListDelegate
        tableView.delegate = placeListDelegate
        placeListDelegate.listVC = self
    }
    
    /// Sets up the views
    private func setUpViews() {
        setUpVisualEffectView()
        setUpCollectionView()
        setUpTableView()
        setUpLoadingView()
        setUpErrorView()
        constrainViews()
    }
    
    /// Sets up the background view
    private func setUpVisualEffectView() {
        let blurEffect = UIBlurEffect(style: .extraLight)
        visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.backgroundColor = .white
        visualEffectView.alpha = 0.8
        view.addSubview(visualEffectView)
    }
    
    /// Sets up the collection view
    private func setUpCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        collectionView.register(PlaceTypeCell.self, forCellWithReuseIdentifier: PlaceTypeCell.identifier)
        view.addSubview(collectionView)
    }
    
    /// Sets up the table view
    private func setUpTableView() {
        tableView.register(PlaceCell.self, forCellReuseIdentifier: PlaceCell.identifier)
        tableView.backgroundColor = .clear
        view.addSubview(tableView)
    }
    
    /// Sets up the loading view
    private func setUpLoadingView() {
        loadingView.startAnimating()
        loadingView.style = .gray
        loadingView.isHidden = true
        view.addSubview(loadingView)
    }
    
    /// Sets up error view
    private func setUpErrorView() {
        errorView.isHidden = true
        view.addSubview(errorView)
    }
}

// MARK: - Actions
extension ListViewController {
    
    /// Action after a button has been tapped
    @objc
    func imageButtonTapped(sender: UIButton) {
        guard sender.isSelected == false else { return }
        imagesButton.forEach { $0.isSelected = ($0 != sender) ? false : true }
        guard let cell = sender.superview?.superview as? PlaceTypeCell,
            let placeType = cell.placeType
            else { return }
        
        removePlaces()
        mapVC?.panelDelegate.lastPanelPosition = nil
        switch placeType {
        case .event:
            mapVC?.mapDelegate.getPlaces(placeType: placeType, dataType: EventsResult.self)
        default:
            mapVC?.mapDelegate.getPlaces(placeType: placeType, dataType: GreenSpacesResult.self)
        }
    }
    
    /// Removes the places frome the previous search
    private func removePlaces() {
        places.removeAll()
        tableView.reloadData()
        guard let mapVC = mapVC else { return }
        mapVC.mapView.removeAnnotations(mapVC.mapView.annotations)
        mapVC.mapView.removeOverlays(mapVC.mapView.overlays)
    }
}

// MARK: - Constraints
extension ListViewController {
    
    /// Constrains  views
    private func constrainViews() {
        constrainVisualEffectView()
        constrainCollectionView()
        constrainTableView()
        constrainLoadingView()
        constrainErrorView()
    }
    
    /// Constrains background view
    private func constrainVisualEffectView() {
        visualEffectView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            visualEffectView.topAnchor.constraint(equalTo: view.topAnchor),
            visualEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            visualEffectView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            visualEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    /// Constrains collection view
    private func constrainCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: view.frame.width / 4)
        ])
    }
    
    /// Constrains table view
    private func constrainTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    /// Constrains loading view
    private func constrainLoadingView() {
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.topAnchor.constraint(equalToSystemSpacingBelow: collectionView.bottomAnchor, multiplier: 5)
        ])
    }
    
    private func constrainErrorView() {
        errorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            errorView.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            errorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            errorView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
