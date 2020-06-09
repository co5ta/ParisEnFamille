//
//  DetailViewController.swift
//  ParisNature
//
//  Created by co5ta on 26/05/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//

import UIKit
import MapKit
import SafariServices
import MessageUI

/// Manages the display of place detail
class DetailViewController: UIViewController {

    /// Map view controller
    weak var mapVC: MapViewController?
    /// The place to manage
    var place: Place? { didSet {setData(for: place)} }
    /// A Blur background
    var visualEffectView: UIVisualEffectView!
    /// The view which display the place
    let topStackView = TopStackView()
    ///
    let scrollView = UIScrollView()
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
        view.addSubview(scrollView)
        scrollView.addSubview(greenspaceStackView)
        scrollView.addSubview(eventStackView)
        setUpCancelButton()
        setUpActions()
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
        cancelButton.addTarget(mapVC, action: #selector(mapVC?.cancelButtonTapped), for: .touchUpInside)
        view.addSubview(cancelButton)
    }
    
    private func setUpActions() {
        topStackView.directionsButton.addTarget(self, action: #selector(directionsButtonTapped), for: .touchUpInside)
        eventStackView.websiteButton.addTarget(self, action: #selector(websiteButtonTapped), for: .touchUpInside)
        eventStackView.phoneButton.addTarget(self, action: #selector(phoneButtonTapped), for: .touchUpInside)
        eventStackView.mailButton.addTarget(self, action: #selector(mailButtonTapped), for: .touchUpInside)
    }
}

// MARK: - Actions
extension DetailViewController {
    
    @objc
    private func directionsButtonTapped() {
        guard let place = place else { return }
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: place.coordinate))
        let options = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        mapItem.name = place.title
        mapItem.openInMaps(launchOptions: options)
    }
    
    @objc
    private func websiteButtonTapped() {
        guard let place = place as? Event,
            let contactUrl = place.contactUrl,
            let url = URL(string: contactUrl)
            else { return }
        let safariVC = SFSafariViewController(url: url)
        safariVC.modalPresentationStyle = .pageSheet
        present(safariVC, animated: true)
    }
    
    @objc
    private func phoneButtonTapped() {
        guard let place = place as? Event,
        let contactPhone = place.contactPhone,
        let phoneNumber = URL(string: "tel://\(contactPhone)")
        else { return }
        UIApplication.shared.open(phoneNumber)
    }
    
    @objc
    private func mailButtonTapped() {
        guard MFMailComposeViewController.canSendMail(),
        let place = place as? Event,
        let contactMail = place.contactMail
        else { return }
        let mail = MFMailComposeViewController()
        mail.mailComposeDelegate = self
        mail.setToRecipients([contactMail])
        present(mail, animated: true)
    }
}

extension DetailViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}

// MARK: - Constraints
extension DetailViewController {
    
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
    
    private func constrainScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topStackView.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
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

// MARK: - Data
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
