//
//  UIFont+Traits.swift
//  ParisEnFamille
//
//  Created by co5ta on 07/06/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//

import UIKit

extension UIFont {
    
    /// Adds the given symbolic trait to the font
    func withTraits(traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
        let descriptor = fontDescriptor.withSymbolicTraits(traits)
        return UIFont(descriptor: descriptor!, size: 0)
    }

    /// Adds the trait bold to the font
    func bold() -> UIFont {
        return withTraits(traits: .traitBold)
    }
}
