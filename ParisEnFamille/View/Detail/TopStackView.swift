//
//  DetailView.swift
//  ParisEnFamille
//
//  Created by co5ta on 03/06/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//

import UIKit
import MapKit

class TopStackView: UIView {

    /// Place data
    var place: Place? { didSet {setData(with: place)} }
    /// Place title
    let titleLabel = UILabel()
    /// Directions button
    let directionsButton = UIButton(type: .system)
    
    /// Initializes view from code
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }

    /// Initializes view from storyboard
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpViews()
    }
}

// MARK: - Setup
extension TopStackView {
    
    /// Sets up the views
    private func setUpViews() {
        setUpTitleLabel()
        setUpDirectionsButton()
        constrainViews()
    }
    
    /// Sets up the title label
    private func setUpTitleLabel() {
        addSubview(titleLabel)
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title2).bold()
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.numberOfLines = 0
    }
    
    /// Sets up the directions button
    private func setUpDirectionsButton() {
        directionsButton.setTitle(Strings.directions, for: .normal)
        directionsButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .subheadline).bold()
        directionsButton.titleLabel?.adjustsFontForContentSizeCategory = true
        directionsButton.titleLabel?.adjustsFontSizeToFitWidth = true
        directionsButton.tintColor = .white
        directionsButton.backgroundColor = .systemBlue
        directionsButton.layer.cornerRadius = 10
        directionsButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        addSubview(directionsButton)
    }
    
    /// Puts data in views
    private func setData(with place: Place?) {
        guard let place = place else { return }
        titleLabel.text = place.title
    }
}

// MARK: - Constraints
extension TopStackView {
    
    /// Constrains the views
    private func constrainViews() {
        constrainTitleLabel()
        constrainDirectionsButton()
    }
    
    /// Constrains the title label
    private func constrainTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.heightAnchor.constraint(lessThanOrEqualToConstant: Config.screenSize.height * 0.25),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            trailingAnchor.constraint(equalToSystemSpacingAfter: titleLabel.trailingAnchor, multiplier: 4)
        ])
    }
    
    /// Constrains the directions button
    private func constrainDirectionsButton() {
        directionsButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            directionsButton.topAnchor.constraint(equalToSystemSpacingBelow: titleLabel.bottomAnchor, multiplier: 2),
            directionsButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            directionsButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomAnchor.constraint(equalToSystemSpacingBelow: directionsButton.bottomAnchor, multiplier: 1)
        ])
    }
}
