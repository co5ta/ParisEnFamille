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
    static var fromNib: Self? {
        UINib(nibName: String(describing: self), bundle: nil)
            .instantiate(withOwner: self, options: nil)
            .first as? Self
    }
}
