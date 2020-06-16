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

    /// The map view controller
    weak var mapVC: MapViewController?
    /// The detail view
    let detailView = DetailView()
    /// The place to manage
    var place: Place? {
        didSet { detailView.place = place }
    }
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
    
    /// Sets up the views
    private func setUpViews() {
        setUpDetailView()
        constrainViews()
    }
    
    /// Sets up the detail view
    private func setUpDetailView() {
        detailView.cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        detailView.topStackView.directionsButton.addTarget(self, action: #selector(directionsButtonTapped), for: .touchUpInside)
        detailView.eventStackView.websiteButton.addTarget(self, action: #selector(websiteButtonTapped), for: .touchUpInside)
        detailView.eventStackView.phoneButton.addTarget(self, action: #selector(phoneButtonTapped), for: .touchUpInside)
        detailView.eventStackView.mailButton.addTarget(self, action: #selector(mailButtonTapped), for: .touchUpInside)
        view.addSubview(detailView)
    }
}

// MARK: - Constraints
extension DetailViewController {
    
    /// Constrains the view
    private func constrainViews() {
        detailView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: view.topAnchor),
            detailView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            detailView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - Actions
extension DetailViewController {
    
    /// Closes the detail view
    @objc
    private func cancelButtonTapped() {
        guard let place = place, let mapVC = mapVC else { return }
//        mapVC.state = .placesList
        mapVC.mapView.deselectAnnotation(place, animated: true)
    }
    
    /// Gets the direction to the place
    @objc
    private func directionsButtonTapped() {
        guard let place = place else { return }
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: place.coordinate))
        let options = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        mapItem.name = place.title
        mapItem.openInMaps(launchOptions: options)
    }
    
    /// Opens the website of the place
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
    
    /// Launchs a call to the contact phone number
    @objc
    private func phoneButtonTapped() {
        guard let place = place as? Event,
            let contactPhone = place.contactPhone,
            let phoneNumber = URL(string: "tel://\(contactPhone)")
            else { return }
        UIApplication.shared.open(phoneNumber)
    }
    
    /// Opens mail app
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

// MARK: - MFMailComposeViewControllerDelegate
extension DetailViewController: MFMailComposeViewControllerDelegate {
    
    /// Tells the delegate that the user wants to dismiss the mail composition view
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
