//
//  DetailViewController.swift
//  ParisNature
//
//  Created by co5ta on 26/05/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var place: Place? { didSet {setData(with: place)} }
    let stackView = UIStackView()
    let titleLabel = UILabel()
    let subTitleLabel = UILabel()
}

// MARK: - Lifecycle
extension DetailViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        setUpViews()
    }
}

// MARK: - Setup
extension DetailViewController {
    
    private func setUpViews() {
        setUpStackView()
        setUpTitleLabel()
        setUpSubTitleLabel()
        constrainViews()
    }
    
    private func setUpStackView() {
        stackView.axis = .vertical
        view.addSubview(stackView)
    }
    
    private func setUpTitleLabel() {
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        stackView.addArrangedSubview(titleLabel)
    }
    
    private func setUpSubTitleLabel() {
        subTitleLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        stackView.addArrangedSubview(subTitleLabel)
    }
}

extension DetailViewController {
    
    private func constrainViews() {
        constrainStackView()
    }
    
    private func constrainStackView() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalToSystemSpacingBelow: view.topAnchor, multiplier: 2),
            stackView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 1),
            stackView.trailingAnchor.constraint(equalToSystemSpacingAfter: view.trailingAnchor, multiplier: 1)
        ])
    }
}

// MARK: - Data
extension DetailViewController {
    
    private func setData(with place: Place?) {
        guard let place = place as? Event else { return }
        titleLabel.text = place.title
        subTitleLabel.text = place.placeType.title
    }
}
