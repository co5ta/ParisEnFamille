//
//  BlurView.swift
//  ParisEnFamille
//
//  Created by co5ta on 02/07/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//

import UIKit

/// A visual effetc view with a blur effect
class BlurView: UIVisualEffectView {
    
    /// Init from the code
    override init(effect: UIVisualEffect? = nil) {
        super.init(effect: effect)
        self.effect = effect ?? UIBlurEffect(style: Style.appBlur)
    }
    
    /// Init from the storyboard
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
