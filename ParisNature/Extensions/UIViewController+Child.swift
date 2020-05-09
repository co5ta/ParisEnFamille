//
//  UIViewController+Child.swift
//  ParisNature
//
//  Created by co5ta on 09/05/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//

import UIKit

extension UIViewController {
    
    /// Handles the whole process of adding child view controller
    func add(child: UIViewController) {
        view.addSubview(child.view)
        addChild(child)
        child.didMove(toParent: self)
    }
    
    /// Handles the whole process of removing child view controller
    func abandon(child: UIViewController) {}
}
