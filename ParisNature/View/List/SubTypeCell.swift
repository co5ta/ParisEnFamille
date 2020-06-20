//
//  SubTypeCell.swift
//  ParisNature
//
//  Created by co5ta on 18/06/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//

import UIKit

/// Cell of the subtype collection view
class SubTypeCell: UICollectionViewCell {
    
    /// Cell identifier
    static let identifier = "SubType"
    /// Button of the subType
    var titleButton = UIButton()
    /// SubType data
    var subType: String? {
        didSet { setData(with: subType) }
    }
    
    /// Init from code
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    /// Init from storyboard
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
}

// MARK: - Setup
extension SubTypeCell {
    
    /// Sets up the views
    private func setUp() {
        titleButton.titleLabel?.font = .preferredFont(forTextStyle: .callout)
        titleButton.titleLabel?.adjustsFontForContentSizeCategory = true
        titleButton.setTitleColor(.systemGray, for: .normal)
        titleButton.setTitleColor(Config.appGray, for: .highlighted)
        titleButton.setTitleColor(.white, for: .selected)
        titleButton.backgroundColor = .clear
        titleButton.layer.cornerRadius = 15
        titleButton.layer.borderWidth = 1
        titleButton.layer.borderColor = Config.appGray.cgColor
        addSubview(titleButton)
        constrain()
    }
    
    /// Configures with data
    private func setData(with subType: String?) {
        guard let subType = subType else { return }
        titleButton.setTitle("     \(subType)     ", for: .normal)
    }
}

// MARK: - Constraints
extension SubTypeCell {
    
    /// Constrains the views
    private func constrain() {
        constrainContentView()
        constrainTitleButton()
    }
    
    /// Constrains the cell content view
    private func constrainContentView() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    /// Constrains the title button
    private func constrainTitleButton() {
        titleButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleButton.topAnchor.constraint(equalToSystemSpacingBelow: contentView.topAnchor, multiplier: 0.5),
            titleButton.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 1),
            contentView.trailingAnchor.constraint(equalToSystemSpacingAfter: titleButton.trailingAnchor, multiplier: 1),
            contentView.bottomAnchor.constraint(equalToSystemSpacingBelow: titleButton.bottomAnchor, multiplier: 5)
        ])
    }
}
