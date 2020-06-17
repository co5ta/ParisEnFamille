//
//  DetailView.swift
//  ParisNature
//
//  Created by co5ta on 09/06/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//

import UIKit

/// View which displays the detail of a space
class DetailView: UIView {

    /// A Blur background
    var visualEffectView: UIVisualEffectView!
    /// The view which display the place
    let topStackView = TopStackView()
    /// The container of place detail
    let scrollView = UIScrollView()
    /// The container of greenspace details
    let greenspaceStackView = GreenSpaceStackView()
    /// The container of event details
    let eventStackView = EventStackView()
    /// Button to close the floating panel
    let cancelButton = CancelButton()
    /// The place to manage
    var place: Place? {
        didSet { setData(with: place) }
    }
    
    /// Initializes for the code
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    /// Initializes for the storyboard
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpViews()
    }
}

// MARK: - Setup
extension DetailView {
    
    /// Sets up the detail view
    private func setUpViews() {
        setUpVisualEffectView()
        addSubview(topStackView)
        addSubview(cancelButton)
        addSubview(scrollView)
        scrollView.addSubview(greenspaceStackView)
        scrollView.addSubview(eventStackView)
        constrainViews()
    }
    
    /// Sets up the background view
    private func setUpVisualEffectView() {
        let blurEffect = UIBlurEffect(style: .extraLight)
        visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.backgroundColor = .white
        visualEffectView.alpha = 0.8
        addSubview(visualEffectView)
    }
    
    /// Puts data in views
    private func setData(with place: Place?) {
        guard let place = place else { return }
        topStackView.place = place
        
        switch place {
        case is GreenSpace:
            greenspaceStackView.place = place
            toggleDetails(of: place)
        case is Event:
            eventStackView.place = place
            toggleDetails(of: place)
        default:
            break
        }
    }
    
    /// Displays the proper stack view to switch between greenspace and event details
    private func toggleDetails(of place: Place) {
        greenspaceStackView.isHidden = place is GreenSpace ? false : true
        eventStackView.isHidden = place is Event ? false : true
    }
}

// MARK: - Constraints
extension DetailView {
    
    /// Constrains the views
    private func constrainViews() {
        constrainVisualEffectView()
        constrainTopStackView()
        constrainScrollView()
        constrainGreenSpaceStackView()
        constrainEventStackView()
        constrainCancelButton()
    }
    
    /// Constrains background view
    private func constrainVisualEffectView() {
        visualEffectView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            visualEffectView.topAnchor.constraint(equalTo: topAnchor),
            visualEffectView.leadingAnchor.constraint(equalTo: leadingAnchor),
            visualEffectView.trailingAnchor.constraint(equalTo: trailingAnchor),
            visualEffectView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    /// Constrains the detail view
    private func constrainTopStackView() {
        topStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topStackView.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 2),
            topStackView.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 2),
            trailingAnchor.constraint(equalToSystemSpacingAfter: topStackView.trailingAnchor, multiplier: 2)
        ])
    }
    
    /// Constrains the scroll view
    private func constrainScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topStackView.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    /// Constrains the greenspace stack view
    private func constrainGreenSpaceStackView() {
        greenspaceStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            greenspaceStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            greenspaceStackView.leadingAnchor.constraint(equalTo: topStackView.leadingAnchor),
            greenspaceStackView.trailingAnchor.constraint(equalTo: topStackView.trailingAnchor)
        ])
    }
    
    /// Constrains the event stack view
    private func constrainEventStackView() {
        eventStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            eventStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            eventStackView.leadingAnchor.constraint(equalTo: topStackView.leadingAnchor),
            eventStackView.trailingAnchor.constraint(equalTo: topStackView.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalToSystemSpacingBelow: eventStackView.bottomAnchor, multiplier: 3)
        ])
    }
    
    /// Constrains the cancel button
    private func constrainCancelButton() {
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cancelButton.heightAnchor.constraint(equalToConstant: 25),
            cancelButton.topAnchor.constraint(equalTo: topStackView.topAnchor),
            cancelButton.trailingAnchor.constraint(equalTo: topStackView.trailingAnchor)
        ])
    }
}
