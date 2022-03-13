//
//  MainCoordinator.swift
//  ParisEnFamille
//
//  Created by co5ta on 08/05/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//

import UIKit

/// Application main coordinator
class MainCoordinator: Coordinator {
    
    /// Navigation controller
    var navigationController: UINavigationController

    /// Initializes the class
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    /// Pushs the home screen
    func start() {
        let viewController = UIStoryboard.init(name: "ListEvents", bundle: nil).instantiateInitialViewController()
        navigationController.pushViewController(viewController!, animated: true)
    }
}

/// Coordinator protocol
protocol Coordinator {
    /// Navigation controller
    var navigationController: UINavigationController { get set }
    /// Pushs the home screen
    func start()
}
