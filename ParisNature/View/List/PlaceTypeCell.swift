//
//  PlaceTypeCell.swift
//  ParisNature
//
//  Created by co5ta on 18/05/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//

import UIKit

/// A custom collection view cell to display all the place types available
class PlaceTypeCell: UICollectionViewCell {
    
    /// Cell identifer
    static let identifier = "PlaceType"
    /// The image of the place in a button
    let imageButton = UIButton()
    /// The title of the place
    let titleLabel = UILabel()
    /// The data of the place type
    var placeType: PlaceType? {
        didSet { setData(with: placeType) }
    }
    
    /// Initializes the class from code
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    /// Initializes the class from storyboard
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpViews()
    }
}

// MARK: - Setup
extension PlaceTypeCell {
    
    /// Sets up the views
    private func setUpViews() {
        setUpButton()
        setUpTitleLabel()
        constrainViews()
    }
    
    /// Sets up the image view
    private func setUpButton() {
        imageButton.tintColor = Style.label
        imageButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 4, bottom: 0, right: 4)
        imageButton.clipsToBounds = true
        contentView.addSubview(imageButton)
    }
    
    /// Styles the images button
    private func setUpTitleLabel() {
        titleLabel.font = .systemFont(ofSize: 14)
        titleLabel.textColor = Style.label
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        contentView.addSubview(titleLabel)
    }
    
    /// Styles the images button
    override func layoutSubviews() {
        super.layoutSubviews()
        imageButton.layoutIfNeeded()
        imageButton.layer.masksToBounds = true
        imageButton.layer.borderWidth = 1
        imageButton.layer.borderColor = Style.label.cgColor
        imageButton.layer.cornerRadius = imageButton.frame.width * 0.5
    }
    
    /// Configures the cell with data
    private func setData(with placeType: PlaceType?) {
        guard let placeType = placeType else { return }
        let imageSelected = UIImage(named: placeType.imageSelectedName)
        imageButton.setImage(imageSelected, for: .selected)
        imageButton.setImage(UIImage(named: placeType.imageName), for: .normal)
        imageButton.setTitle(placeType.title, for: .normal)
        titleLabel.text = placeType.title
    }
}

// MARK: - Constraints
extension PlaceTypeCell {
    
    /// Contrains the views
    private func constrainViews() {
        constrainButton()
        constrainTitleLabel()
    }
    
    /// Contrains the image view
    private func constrainButton() {
        imageButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageButton.widthAnchor.constraint(equalToConstant: contentView.frame.width * 0.5),
            imageButton.heightAnchor.constraint(equalTo: imageButton.widthAnchor),
            imageButton.topAnchor.constraint(equalToSystemSpacingBelow: contentView.topAnchor, multiplier: 2)
        ])
    }
    
    /// Contrains the title label
    private func constrainTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalToSystemSpacingBelow: imageButton.bottomAnchor, multiplier: 0.5),
            titleLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 0),
            trailingAnchor.constraint(equalToSystemSpacingAfter: titleLabel.trailingAnchor, multiplier: 0),
            bottomAnchor.constraint(greaterThanOrEqualToSystemSpacingBelow: titleLabel.bottomAnchor, multiplier: 0.1)
        ])
    }
}
