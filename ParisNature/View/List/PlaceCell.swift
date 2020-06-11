//
//  PlaceCell.swift
//  ParisNature
//
//  Created by co5ta on 20/05/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//

import UIKit

class PlaceCell: UITableViewCell {
    var place: Place? { didSet {configure(with: place)} }
    let titleLabel = UILabel()
    let subheadingLabel = UILabel()
    static let identifier = "PlaceCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpViews()
    }
}

extension PlaceCell {
    private func setUpViews() {
        backgroundColor = .clear
        setUpNameLabel()
        setUpAddressLabel()
        constrainViews()
    }
    
    private func setUpNameLabel() {
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        titleLabel.numberOfLines = 0
        contentView.addSubview(titleLabel)
    }
    
    private func setUpAddressLabel() {
        subheadingLabel.font = UIFont.preferredFont(forTextStyle: .callout)
        subheadingLabel.textColor = .systemGray
        subheadingLabel.numberOfLines = 0
        contentView.addSubview(subheadingLabel)
    }
    
    private func constrainViews() {
        constrainNameLabel()
        constrainAddressLabel()
    }
    
    private func constrainNameLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalToSystemSpacingBelow: contentView.topAnchor, multiplier: 2),
            titleLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 2),
            contentView.trailingAnchor.constraint(equalToSystemSpacingAfter: titleLabel.trailingAnchor, multiplier: 2)
        ])
    }
    
    private func constrainAddressLabel() {
        subheadingLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
//            subheadingLabel.topAnchor.constraint(equalToSystemSpacingBelow: titleLabel.bottomAnchor, multiplier: 0.1),
            subheadingLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            subheadingLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subheadingLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            contentView.bottomAnchor.constraint(equalToSystemSpacingBelow: subheadingLabel.bottomAnchor, multiplier: 2)
        ])
    }
}

extension PlaceCell {
    private func configure(with place: Place?) {
        guard let place = place else { return }
        titleLabel.text = place.title
        subheadingLabel.text = place.subheading
    }
}
