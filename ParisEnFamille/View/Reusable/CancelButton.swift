//
//  CancelButton.swift
//  ParisEnFamille
//
//  Created by co5ta on 16/06/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//

import UIKit

/// A button to trigger a cancel action
class CancelButton: UIButton {

    /// init form the code
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    /// Init from the storyboard
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    /// Sets up the view
    private func setup() {
        setImage(UIImage(named: "close"), for: .normal)
        setImage(UIImage(named: "closeSelected"), for: .highlighted)
        constrainView()
    }
    
    /// Constrains the view
    private func constrainView() {
        widthAnchor.constraint(equalTo: heightAnchor).isActive = true
    }
}
