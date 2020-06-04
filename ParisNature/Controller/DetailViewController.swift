//
//  DetailViewController.swift
//  ParisNature
//
//  Created by co5ta on 26/05/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    /// The place to manage
    var place: Place? { didSet {setData(for: place)} }
    ///  The view which display the place
    let topStackView = TopStackView()
    ///
    let greenspaceStackView = GreenSpaceStackView()
}

// MARK: - Lifecycle
extension DetailViewController {
    
    /// Initializes the view controller
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
}

// MARK: - Setup
extension DetailViewController {
    
    /// Sets up the detail view
    private func setUpViews() {
        view.backgroundColor = .white
        view.addSubview(topStackView)
        view.addSubview(greenspaceStackView)
        constrainViews()
    }
}

// MARK: - Constraints
extension DetailViewController {
    
    private func constrainViews() {
        constrainTopStackView()
        constrainGreenSpaceStackView()
    }
    
    /// Constrains the detail view
    private func constrainTopStackView() {
        topStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topStackView.topAnchor.constraint(equalToSystemSpacingBelow: view.topAnchor, multiplier: 2),
            topStackView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 1),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: topStackView.trailingAnchor, multiplier: 1)
        ])
    }
    
    private func constrainGreenSpaceStackView() {
        greenspaceStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            greenspaceStackView.topAnchor.constraint(equalToSystemSpacingBelow: topStackView.bottomAnchor, multiplier: 1),
            greenspaceStackView.leadingAnchor.constraint(equalTo: topStackView.leadingAnchor),
            greenspaceStackView.trailingAnchor.constraint(equalTo: topStackView.trailingAnchor)
        ])
    }
}

extension DetailViewController {
    
    private func setData(for place: Place?) {
        guard let place = place else { return }
        topStackView.place = place
        greenspaceStackView.place = place
    }
}
