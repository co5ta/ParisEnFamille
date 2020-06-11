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
    
    /// List of places
    let listView = ListView()
    // swiftlint:disable weak_delegate
    let placeListDelegate = PlaceListDelegate()
    // swiftlint:disable weak_delegate
    let placeTypeListDelegate = PlaceTypeListDelegate()
    /// List of places founded by the research
    var places = [Place]() {
        didSet { placeListDelegate.updateTableView(oldValue) }
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
        listView.collectionView.dataSource = placeTypeListDelegate
        listView.collectionView.delegate = placeTypeListDelegate
        placeTypeListDelegate.listVC = self
        listView.tableView.dataSource = placeListDelegate
        listView.tableView.delegate = placeListDelegate
        placeListDelegate.listVC = self
    }
    
    /// Sets up the views
    private func setUpViews() {
        view.addSubview(listView)
        constrainViews()
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
