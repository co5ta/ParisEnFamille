//
//  PlaceTypeCollectionViewCell.swift
//  ParisNature
//
//  Created by co5ta on 18/05/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//

import UIKit

class PlaceTypeCell: UICollectionViewCell {
    
    var placeType: PlaceType? { didSet {configure(with: placeType)} }
    let imageButton = UIButton()
    let titleLabel = UILabel()
    static let identifier = "PlaceType"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        constrainViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpViews()
        constrainViews()
    }
}

// MARK: - Setup
extension PlaceTypeCell {
    
    private func setUpViews() {
        backgroundColor = .clear
        setUpImageView()
        setUpTitleLabel()
    }
    
    private func setUpImageView() {
//        imageButton.backgroundColor = .white
//        imageButton.layer.borderColor = UIColor.black.cgColor
//        imageButton.layer.borderWidth = 1
        imageButton.clipsToBounds = true
        contentView.addSubview(imageButton)
    }
    
    private func setUpTitleLabel() {
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        contentView.addSubview(titleLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        imageButton.layoutIfNeeded()
//        imageButton.layer.masksToBounds = true
//        imageButton.layer.cornerRadius = imageButton.frame.width * 0.5
//        imageButton.layer.cornerRadius = 5
    }
}

// MARK: - Constraints
extension PlaceTypeCell {
    
    private func constrainViews() {
        constrainImageView()
        constrainTitleLabel()
    }
    
    private func constrainImageView() {
        imageButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageButton.widthAnchor.constraint(equalToConstant: contentView.frame.width * 0.4),
            imageButton.heightAnchor.constraint(equalTo: imageButton.widthAnchor),
            imageButton.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
    }
    
    private func constrainTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalToSystemSpacingBelow: imageButton.bottomAnchor, multiplier: 1),
            titleLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 1),
            trailingAnchor.constraint(equalToSystemSpacingAfter: titleLabel.trailingAnchor, multiplier: 1)
        ])
    }
}

// MARK: - Data
extension PlaceTypeCell {
    
    private func configure(with placeType: PlaceType?) {
        guard let placeType = placeType else { return }
        imageButton.setImage(UIImage(named: placeType.imageName), for: .normal) 
        titleLabel.text = placeType.title
    }
}
