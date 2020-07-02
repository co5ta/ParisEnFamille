//
//  PlaceCell.swift
//  ParisNature
//
//  Created by co5ta on 20/05/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//

import UIKit

/// A custom table view cell to display all the place founded after a research
class PlaceCell: UITableViewCell {
    
    /// Title of the place
    let titleLabel = UILabel()
    /// Subheading of the place
    let subheadingLabel = UILabel()
    /// Cell identifier
    static let identifier = "PlaceCell"
    /// Data of the place
    var place: Place? {
        didSet { setData(with: place) }
    }
    
    /// Initializes the class from code
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
    }
    
    /// Initializes the class from storyboard
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpViews()
    }
}

// MARK: - Setup
extension PlaceCell {
    
    /// Sets up the views
    private func setUpViews() {
        backgroundColor = .clear
        setUpTitleLabel()
        setUpSubheadingLabel()
        constrainViews()
    }
    
    /// Sets up the title label
    private func setUpTitleLabel() {
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        titleLabel.textColor = Style.label
        titleLabel.numberOfLines = 0
        contentView.addSubview(titleLabel)
    }
    
    /// Sets up the subheading label
    private func setUpSubheadingLabel() {
        subheadingLabel.font = UIFont.preferredFont(forTextStyle: .callout)
        subheadingLabel.textColor = Style.secondarylabel
        subheadingLabel.numberOfLines = 0
        contentView.addSubview(subheadingLabel)
    }
    
    /// Puts data in views
    private func setData(with place: Place?) {
        guard let place = place else { return }
        titleLabel.text = place.title
        subheadingLabel.text = place.subheading
    }
}

// MARK: - Constrains
extension PlaceCell {
    
    /// Constrains the subheading label
    private func constrainViews() {
        constrainTitleLabel()
        constrainSubheadingLabel()
    }
    
    /// Constrains the title label
    private func constrainTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalToSystemSpacingBelow: contentView.topAnchor, multiplier: 2),
            titleLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 2),
            contentView.trailingAnchor.constraint(equalToSystemSpacingAfter: titleLabel.trailingAnchor, multiplier: 2)
        ])
    }
    
    /// Constrains the subheading label
    private func constrainSubheadingLabel() {
        subheadingLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subheadingLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            subheadingLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subheadingLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            contentView.bottomAnchor.constraint(equalToSystemSpacingBelow: subheadingLabel.bottomAnchor, multiplier: 2)
        ])
    }
}
