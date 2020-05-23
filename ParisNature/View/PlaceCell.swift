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
    let addressLabel = UILabel()
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
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        titleLabel.numberOfLines = 0
        contentView.addSubview(titleLabel)
    }
    
    private func setUpAddressLabel() {
        addressLabel.font = UIFont.preferredFont(forTextStyle: .callout)
        addressLabel.textColor = .systemGray
        addressLabel.numberOfLines = 0
        contentView.addSubview(addressLabel)
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
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addressLabel.topAnchor.constraint(equalToSystemSpacingBelow: titleLabel.bottomAnchor, multiplier: 1),
            addressLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            addressLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            contentView.bottomAnchor.constraint(equalToSystemSpacingBelow: addressLabel.bottomAnchor, multiplier: 2)
        ])
    }
}

extension PlaceCell {
    private func configure(with place: Place?) {
        guard let place = place else { return }
        titleLabel.text = place.title
        addressLabel.text = place.address
    }
}
