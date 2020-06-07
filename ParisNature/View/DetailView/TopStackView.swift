//
//  DetailView.swift
//  ParisNature
//
//  Created by co5ta on 03/06/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//

import UIKit
import MapKit

class TopStackView: UIView {

    ///
    var place: Place? { didSet {setData(with: place)} }
    ///
    let titleLabel = UILabel()
    ///
    let subheadingLabel = UILabel()
    ///
    let directionsButton = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpViews()
    }
}

extension TopStackView {
    
    private func setUpViews() {
        setUpTitleLabel()
        setUpSubTitleLabel()
        setUpDirectionsButton()
        constrainViews()
    }
    
    private func setUpTitleLabel() {
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        titleLabel.numberOfLines = 0
        addSubview(titleLabel)
    }
    
    private func setUpSubTitleLabel() {
        subheadingLabel.font = UIFont.preferredFont(forTextStyle: .callout)
        subheadingLabel.textColor = .systemGray
        addSubview(subheadingLabel)
    }
    
    /// Sets up
    private func setUpDirectionsButton() {
        directionsButton.setTitle("Directions", for: .normal)
        directionsButton.tintColor = .white
        directionsButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .callout)
        directionsButton.backgroundColor = .systemBlue
        directionsButton.layer.cornerRadius = 10
        directionsButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        addSubview(directionsButton)
    }
    
    private func constrainViews() {
        constrainTitleLabel()
        constrainSubHeadingLabel()
        constrainDirectionsButton()
    }
    
    private func constrainTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            trailingAnchor.constraint(equalToSystemSpacingAfter: titleLabel.trailingAnchor, multiplier: 4)
        ])
    }
    
    private func constrainSubHeadingLabel() {
        subheadingLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subheadingLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            subheadingLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            subheadingLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    private func constrainDirectionsButton() {
        directionsButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            directionsButton.topAnchor.constraint(equalToSystemSpacingBelow: subheadingLabel.bottomAnchor, multiplier: 2),
            directionsButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            directionsButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            directionsButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: - Data
extension TopStackView {
    
    private func setData(with place: Place?) {
        guard let place = place else { return }
        titleLabel.text = place.title
        subheadingLabel.text = place.subheading
    }
}
