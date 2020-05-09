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
    let map = MKMapView()
    
    /// Initializes the instance
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        setUp()
    }
    
    /// Sets up the instance
    private func setUp() {
        setUpMap()
    }
    
    /// Sets up the map
    private func setUpMap() {
        view.addSubview(map)
        constraintMap()
    }
    
    /// Adds constraints to map
    private func constraintMap() {
        map.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            map.topAnchor.constraint(equalTo: view.topAnchor),
            map.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            map.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            map.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
