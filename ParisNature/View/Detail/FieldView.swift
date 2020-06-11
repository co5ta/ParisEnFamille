//
//  DetailFieldView.swift
//  ParisNature
//
//  Created by co5ta on 03/06/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//

import UIKit

/// A view which displays an information about the place in a section
class FieldView: UIView {

    /// A line to separate the informations
    let separatorView = UIView()
    /// Title of field
    let titleLabel = UILabel()
    /// Value of the field
    let valueLabel = UILabel()
    
    /// Initializes from the code
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    /// Initializes from the storyboard
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpViews()
    }
}

// MARK: - Setup
extension FieldView {
    
    /// Sets up the views
    private func setUpViews() {
        setUpSeparatorView()
        setUpTitleLabel()
        setUpValueLabel()
        constrainViews()
    }
    
    /// Sets up separator view
    private func setUpSeparatorView() {
        separatorView.backgroundColor = Config.appGray
        addSubview(separatorView)
    }
    
    /// Sets up the title label
    private func setUpTitleLabel() {
        titleLabel.font = .preferredFont(forTextStyle: .subheadline)
        titleLabel.translatesAutoresizingMaskIntoConstraints = true
        titleLabel.textColor = .systemGray
        addSubview(titleLabel)
    }
    
    /// Sets up the value label
    private func setUpValueLabel() {
        valueLabel.font = .preferredFont(forTextStyle: .callout)
        valueLabel.translatesAutoresizingMaskIntoConstraints = true
        valueLabel.numberOfLines = 0
        addSubview(valueLabel)
    }
    
    /// Puts data in views
    func setData(title: String, value: String, separatorHidden: Bool = false) {
        separatorView.isHidden = separatorHidden
        titleLabel.text = title.capitalized
        valueLabel.text = value
    }
}

// MARK: - Constraints
extension FieldView {
    
    /// Constrains the views
    private func constrainViews() {
        constrainSeparatorView()
        constrainTitleLabel()
        constrainValueLabel()
    }
    
    /// Constrains the separator view
    private func constrainSeparatorView() {
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            separatorView.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 1),
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    /// Constrains the title label
    private func constrainTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalToSystemSpacingBelow: separatorView.bottomAnchor, multiplier: 2),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
    }
    
    /// Constrains the value label
    private func constrainValueLabel() {
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            valueLabel.topAnchor.constraint(equalToSystemSpacingBelow: titleLabel.bottomAnchor, multiplier: 0.5),
            valueLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            valueLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomAnchor.constraint(equalToSystemSpacingBelow: valueLabel.bottomAnchor, multiplier: 1)
        ])
    }
}
