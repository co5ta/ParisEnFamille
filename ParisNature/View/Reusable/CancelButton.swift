//
//  CancelButton.swift
//  ParisNature
//
//  Created by co5ta on 16/06/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//

import UIKit

class CancelButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        setImage(UIImage(named: "close"), for: .normal)
        setImage(UIImage(named: "closeSelected"), for: .highlighted)
        constrainView()
    }
    
    private func constrainView() {
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalTo: heightAnchor)
        ])
    }
}
