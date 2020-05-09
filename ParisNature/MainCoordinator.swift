//
//  MainCoordinator.swift
//  ParisNature
//
//  Created by co5ta on 08/05/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//

import UIKit

class MainCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        navigationController.pushViewController(ViewController(), animated: true)
    }
}

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    func start()
}
