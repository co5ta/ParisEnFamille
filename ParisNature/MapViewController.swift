//
//  MapViewController.swift
//  ParisNature
//
//  Created by co5ta on 08/05/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//

import UIKit

/// View controller of the map
class MapViewController: UIViewController {
    
    /// View controller of the map content
    let mapContent = MapContentViewController()
}

// MARK: - Lifecycle
extension MapViewController {
    
    /// Initializes the instance
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
}
 
// MARK: - Setup
extension MapViewController {
    
    /// Sets up the instance
    private func setUp() {
        setUpDefaultProperties()
        setUpMapContent()
    }
    
    /// Sets up defaults view controller properties
    private func setUpDefaultProperties() {
        view.backgroundColor = .blue
    }
    
    /// Sets up defaults map content
    private func setUpMapContent() {
        add(child: mapContent)
    }
}
