//
//  ErrorView.swift
//  ParisNature
//
//  Created by co5ta on 09/06/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//

import UIKit

class ErrorView: UIView {

    var error: NetworkError? { didSet { setData(with: error)} }
    var stackView = UIStackView()
    var imageView = UIImageView()
    var messageLabel = UILabel()
    
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
extension ErrorView {

    private func setUpViews() {
//        backgroundColor = .blue
        setUpStackView()
        setUpImageView()
        setUpMessageLabel()
        constrainViews()
    }
    
    private func setUpStackView() {
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 20
        addSubview(stackView)
    }
    
    private func setUpImageView() {
        stackView.addArrangedSubview(imageView)
    }
    
    private func setUpMessageLabel() {
        messageLabel.font = .preferredFont(forTextStyle: .headline)
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.adjustsFontForContentSizeCategory = true
        stackView.addArrangedSubview(messageLabel)
    }
    
    private func setData(with error: NetworkError?) {
        guard let error = error else { return }
        messageLabel.text = error.errorDescription
        imageView.image = UIImage(named: error.imageName)
    }
}

// MARK: - Constraints
extension ErrorView {
    
    private func constrainViews() {
        constrainStackView()
        constrainImageView()
        constrainImageLabel()
    }
    
    private func constrainStackView() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 5),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    private func constrainImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            imageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.3)
        ])
    }
    
    private func constrainImageLabel() {
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            messageLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.75)
        ])
    }
}
