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
    let mapContentVC = MapContentViewController()
    
    /// Initializes the instance
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        setUp()
    }
    
    /// Sets up the instance
    private func setUp() {
        add(child: mapContentVC)
    }
}
