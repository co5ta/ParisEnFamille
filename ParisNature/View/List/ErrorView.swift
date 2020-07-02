//
//  ErrorView.swift
//  ParisNature
//
//  Created by co5ta on 09/06/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//

import UIKit

/// A custom view to display a pretty error message
class ErrorView: UIView {

    /// Container of the views
    var stackView = UIStackView()
    /// Image of the error
    var imageView = UIImageView()
    /// Message of the error
    var messageLabel = UILabel()
    /// Data of the error
    var error: NetworkError? {
        didSet { setData(with: error) }
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
extension ErrorView {

    /// Sets up the views
    private func setUpViews() {
        clipsToBounds = true
        setUpStackView()
        setUpImageView()
        setUpMessageLabel()
        constrainViews()
    }
    
    /// Sets up the stack view
    private func setUpStackView() {
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 20
        addSubview(stackView)
    }
    
    /// Sets up the image view
    private func setUpImageView() {
        imageView.tintColor = Style.label
        stackView.addArrangedSubview(imageView)
    }
    
    /// Sets up the message label
    private func setUpMessageLabel() {
        messageLabel.font = .preferredFont(forTextStyle: .headline)
        messageLabel.textColor = Style.label
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.adjustsFontForContentSizeCategory = true
        stackView.addArrangedSubview(messageLabel)
    }
    
    /// Puts data in views
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
