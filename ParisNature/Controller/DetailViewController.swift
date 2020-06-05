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
    /// A Blur background
    var visualEffectView: UIVisualEffectView!
    /// The view which display the place
    let topStackView = TopStackView()
    /// The container of greenspace details
    let greenspaceStackView = GreenSpaceStackView()
    /// The container of event details
    let eventStackView = EventStackView()
    /// Button to close the floating panel
    let cancelButton = UIButton()
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
        setUpVisualEffectView()
        view.addSubview(topStackView)
        view.addSubview(greenspaceStackView)
        view.addSubview(eventStackView)
        setUpCancelButton()
        constrainViews()
    }
    
    /// Sets up the background view
    private func setUpVisualEffectView() {
        let blurEffect = UIBlurEffect(style: .extraLight)
        visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.backgroundColor = .white
        visualEffectView.alpha = 0.8
        view.addSubview(visualEffectView)
    }
    
    private func setUpCancelButton() {
        cancelButton.setImage(UIImage(named: "close"), for: .normal)
        cancelButton.setImage(UIImage(named: "closeSelected"), for: .highlighted)
        view.addSubview(cancelButton)
    }
}

// MARK: - Constraints
extension DetailViewController {
    
    private func constrainViews() {
        constrainVisualEffectView()
        constrainTopStackView()
        constrainGreenSpaceStackView()
        constrainEventStackView()
        constrainCancelButton()
    }
    
    /// Constrains background view
    private func constrainVisualEffectView() {
        visualEffectView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            visualEffectView.topAnchor.constraint(equalTo: view.topAnchor),
            visualEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            visualEffectView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            visualEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    /// Constrains the detail view
    private func constrainTopStackView() {
        topStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topStackView.topAnchor.constraint(equalToSystemSpacingBelow: view.topAnchor, multiplier: 2),
            topStackView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: topStackView.trailingAnchor, multiplier: 2)
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
    
    private func constrainEventStackView() {
        eventStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            eventStackView.topAnchor.constraint(equalToSystemSpacingBelow: topStackView.bottomAnchor, multiplier: 1),
            eventStackView.leadingAnchor.constraint(equalTo: topStackView.leadingAnchor),
            eventStackView.trailingAnchor.constraint(equalTo: topStackView.trailingAnchor)
        ])
    }
    
    private func constrainCancelButton() {
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cancelButton.heightAnchor.constraint(equalToConstant: 25),
            cancelButton.widthAnchor.constraint(equalTo: cancelButton.heightAnchor),
            cancelButton.topAnchor.constraint(equalTo: topStackView.topAnchor),
            cancelButton.trailingAnchor.constraint(equalTo: topStackView.trailingAnchor)
        ])
    }
}

extension DetailViewController {
    
    private func setData(for place: Place?) {
        guard let place = place else { return }
        topStackView.place = place
        
        switch place {
        case is GreenSpace:
            greenspaceStackView.place = place
            displayDetails(of: place)
        case is Event:
            eventStackView.place = place
            displayDetails(of: place)
        default:
            print(#function, "This type of place is not handled")
        }
    }
    
    private func displayDetails(of place: Place) {
        greenspaceStackView.isHidden = place is GreenSpace ? false : true
        eventStackView.isHidden = place is Event ? false : true
    }
}
