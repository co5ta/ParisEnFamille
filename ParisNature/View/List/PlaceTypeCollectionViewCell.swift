//
//  PlaceTypeCollectionViewCell.swift
//  ParisNature
//
//  Created by co5ta on 18/05/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//

import UIKit

/// A custom collection view cell to display all the place types available
class PlaceTypeCollectionViewCell: UICollectionViewCell {
    
    /// The image of the place in a button
    let imageButton = UIButton()
    /// The title of the place
    let titleLabel = UILabel()
    /// Cell identifer
    static let identifier = "PlaceType"
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
extension PlaceTypeCollectionViewCell {
    
    /// Sets up the views
    private func setUpViews() {
        setUpImageView()
        setUpTitleLabel()
        constrainViews()
    }
    
    /// Sets up the image view
    private func setUpImageView() {
        imageButton.clipsToBounds = true
        contentView.addSubview(imageButton)
    }
    
    /// Styles the images button
    private func setUpTitleLabel() {
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        contentView.addSubview(titleLabel)
    }
    
    /// Styles the images button
    override func layoutSubviews() {
        super.layoutSubviews()
        imageButton.layoutIfNeeded()
        imageButton.layer.masksToBounds = true
        imageButton.layer.cornerRadius = imageButton.frame.width * 0.5
        imageButton.layer.borderColor = UIColor.black.cgColor
        imageButton.layer.borderWidth = 1
    }
    
    /// Configures the cell with data
    private func setData(with placeType: PlaceType?) {
        guard let placeType = placeType else { return }
        let imageSelected = UIImage(named: placeType.imageSelectedName)
        imageButton.setImage(imageSelected, for: .selected)
        imageButton.setImage(imageSelected, for: .highlighted)
        imageButton.setImage(UIImage(named: placeType.imageName), for: .normal)
        imageButton.setTitle(placeType.title, for: .normal)
        titleLabel.text = placeType.title
    }
}

// MARK: - Constraints
extension PlaceTypeCollectionViewCell {
    
    /// Contrains the views
    private func constrainViews() {
        constrainImageView()
        constrainTitleLabel()
    }
    
    /// Contrains the image view
    private func constrainImageView() {
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
            titleLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 1),
            trailingAnchor.constraint(equalToSystemSpacingAfter: titleLabel.trailingAnchor, multiplier: 1)
        ])
    }
}
