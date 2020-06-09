//
//  DetailView.swift
//  ParisNature
//
//  Created by co5ta on 09/06/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//

import UIKit

class DetailView: UIView {

    /// The place to manage
    var place: Place? { didSet {setData(for: place)} }
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
    let cancelButton = UIButton()
    
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
        addSubview(scrollView)
        scrollView.addSubview(greenspaceStackView)
        scrollView.addSubview(eventStackView)
        setUpCancelButton()
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
    
    private func setUpCancelButton() {
        cancelButton.setImage(UIImage(named: "close"), for: .normal)
        cancelButton.setImage(UIImage(named: "closeSelected"), for: .highlighted)
        addSubview(cancelButton)
    }
    
    private func setData(for place: Place?) {
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
            print(#function, "This type of place is not handled")
        }
    }
    
    private func toggleDetails(of place: Place) {
        greenspaceStackView.isHidden = place is GreenSpace ? false : true
        eventStackView.isHidden = place is Event ? false : true
    }
}

// MARK: - Constraints
extension DetailView {
    
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
    
    private func constrainScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topStackView.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func constrainGreenSpaceStackView() {
        greenspaceStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            greenspaceStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            greenspaceStackView.leadingAnchor.constraint(equalTo: topStackView.leadingAnchor),
            greenspaceStackView.trailingAnchor.constraint(equalTo: topStackView.trailingAnchor)
        ])
    }
    
    private func constrainEventStackView() {
        eventStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            eventStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            eventStackView.leadingAnchor.constraint(equalTo: topStackView.leadingAnchor),
            eventStackView.trailingAnchor.constraint(equalTo: topStackView.trailingAnchor),
//            eventStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
            scrollView.bottomAnchor.constraint(equalToSystemSpacingBelow: eventStackView.bottomAnchor, multiplier: 3)
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
