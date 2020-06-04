//
//  DetailView.swift
//  ParisNature
//
//  Created by co5ta on 03/06/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//

import UIKit
import MapKit

class TopStackView: UIStackView {

    ///
    var place: Place? { didSet {setData(with: place)} }
    ///
    let titleLabel = UILabel()
    ///
    let subHeadingLabel = UILabel()
    ///
    let directionsButton = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
        setUpViews()
    }
}

extension TopStackView {
    
    private func setUpViews() {
        setUpDefaultProperties()
        setUpTitleLabel()
        setUpSubTitleLabel()
        setUpDirectionsButton()
    }
    
    private func setUpDefaultProperties() {
        axis = .vertical
        spacing = 2
    }
    
    private func setUpTitleLabel() {
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        titleLabel.numberOfLines = 0
        addArrangedSubview(titleLabel)
    }
    
    private func setUpSubTitleLabel() {
        subHeadingLabel.font = UIFont.preferredFont(forTextStyle: .callout)
        subHeadingLabel.textColor = .systemGray
        addArrangedSubview(subHeadingLabel)
    }
    
    /// Sets up
    private func setUpDirectionsButton() {
        directionsButton.setTitle("Directions", for: .normal)
        directionsButton.tintColor = .white
        directionsButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .callout)
        directionsButton.backgroundColor = .systemBlue
        directionsButton.layer.cornerRadius = 10
        directionsButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        setCustomSpacing(15, after: subHeadingLabel)
        addArrangedSubview(directionsButton)
    }
}

// MARK: - Data
extension TopStackView {
    
    private func setData(with place: Place?) {
        guard let place = place else { return }
        titleLabel.text = place.title
        subHeadingLabel.text = place.subheading
    }
}
