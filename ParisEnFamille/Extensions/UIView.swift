//
//  UIView.swift
//  ParisEnFamille
//
//  Created by Costa Monzili on 18/03/2022.
//  Copyright © 2022 Co5ta. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    /// Instantiate a view from its nib
    static var fromNib: Self? {
        UINib(nibName: String(describing: self), bundle: nil)
            .instantiate(withOwner: self, options: nil)
            .first as? Self
    }
    
    /// Add a subview contrained to view anchors
    func addConstrained(subview: UIView) {
        addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subview.topAnchor.constraint(equalTo: topAnchor),
            subview.bottomAnchor.constraint(equalTo: bottomAnchor),
            subview.leadingAnchor.constraint(equalTo: leadingAnchor),
            subview.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
