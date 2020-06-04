//
//  DetailFieldView.swift
//  ParisNature
//
//  Created by co5ta on 03/06/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//

import UIKit

class FieldView: UIView {

    let separatorView = UIView()
    let titleLabel = UILabel()
    let valueLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpViews()
    }
}

// MARK: - Setup
extension FieldView {
    
    private func setUpViews() {
        setUpSeparatorView()
        setUpTitleLabel()
        setUpValueLabel()
        constrainViews()
    }
    
    /// Sets up separator view
    private func setUpSeparatorView() {
        separatorView.backgroundColor = .lightGray
        addSubview(separatorView)
    }
    
    private func setUpTitleLabel() {
        titleLabel.font = .preferredFont(forTextStyle: .footnote)
        titleLabel.textColor = .systemGray
        addSubview(titleLabel)
    }
    
    private func setUpValueLabel() {
        valueLabel.font = .preferredFont(forTextStyle: .subheadline)
        addSubview(valueLabel)
    }
}

// MARK: - Constraints
extension FieldView {
    
    private func constrainViews() {
        constrainSeparatorView()
        constrainTitleLabel()
        constrainValueLabel()
    }
    
    private func constrainSeparatorView() {
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            separatorView.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 1),
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    private func constrainTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalToSystemSpacingBelow: separatorView.bottomAnchor, multiplier: 2),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
    }
    
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

extension FieldView {
    
    func setData(title: String, value: String, separatorHidden: Bool = false) {
        separatorView.isHidden = separatorHidden
        titleLabel.text = title.capitalized
        valueLabel.text = value
    }
}
