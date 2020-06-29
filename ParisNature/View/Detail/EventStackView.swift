//
//  EventStackView.swift
//  ParisNature
//
//  Created by co5ta on 05/06/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//

import UIKit

/// A stack view which contains the details about an event
class EventStackView: UIStackView {

    /// Event address
    let addressFieldView = FieldView()
    /// Start and end dates of the event
    let dateFieldView = FieldView()
    /// A short description of the event
    let leadTextFieldView = FieldView()
    /// A longer description of the event
    let descriptionTextView = UITextView()
    /// Indicates if the access is free or paying
    let accessFieldView = FieldView()
    /// Price detail
    let priceDetailLabel = UILabel()
    /// The name of the contact
    let contactFieldView = FieldView()
    /// Stack view containing the contact informations
    let contactStackView = UIStackView()
    /// Website button
    let websiteButton = UIButton(type: .system)
    /// Phone button
    let phoneButton = UIButton(type: .system)
    /// Mail button
    let mailButton = UIButton(type: .system)
    /// Data of the event
    var place: Place? {
        didSet { setUpData(with: place) }
    }
    
    /// Initializes the class from code
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }

    /// Initializes the class from storyboard
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setUpViews()
    }
}

// MARK: - Setup
extension EventStackView {
    
    /// Sets up the views
    private func setUpViews() {
        axis = .vertical
        addArrangedSubview(addressFieldView)
        addArrangedSubview(dateFieldView)
        addArrangedSubview(accessFieldView)
        setUpPriceDetail()
        addArrangedSubview(leadTextFieldView)
        setUpDescriptionLabel()
        addArrangedSubview(contactFieldView)
        setUpContactStackView()
        setUpContactButton(button: phoneButton, imageName: "phone")
        setUpContactButton(button: websiteButton, imageName: "safari")
        setUpContactButton(button: mailButton, imageName: "mail")
        constrainContactButtons()
    }
    
    /// Sets up description label
    private func setUpDescriptionLabel() {
        addArrangedSubview(descriptionTextView)
        descriptionTextView.isScrollEnabled = false
        descriptionTextView.isEditable = false
        descriptionTextView.isSelectable = false
        descriptionTextView.textContainer.lineFragmentPadding = 0
        descriptionTextView.backgroundColor = .clear
    }
    
    /// Sets up price detail
    private func setUpPriceDetail() {
        addArrangedSubview(priceDetailLabel)
        priceDetailLabel.numberOfLines = 0
        priceDetailLabel.font = .preferredFont(forTextStyle: .callout)
        setCustomSpacing(10, after: priceDetailLabel)
    }
    
    /// Sets up the contact stack view
    private func setUpContactStackView() {
        contactStackView.spacing = 10
        contactStackView.distribution = .fillEqually
        setCustomSpacing(10, after: contactFieldView)
        addArrangedSubview(contactStackView)
    }
    
    /// Sets up a contact button
    private func setUpContactButton(button: UIButton, imageName: String) {
        button.backgroundColor = Config.appGray
        button.setImage(UIImage(named: imageName), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.contentEdgeInsets = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        button.layer.cornerRadius = 5
        contactStackView.addArrangedSubview(button)
    }
    
    /// Sets up view with data
    private func setUpData(with place: Place?) {
        guard let place = place as? Event else { return }
        addressFieldView.setData(title: "Address", value: place.address, separatorHidden: true)
        dateFieldView.setData(title: "Date", value: place.dateDescription, isHTML: true)
        leadTextFieldView.setData(title: "Description", value: place.leadText)
        let description = place.descriptionText + "<style>img {width: \(frame.width)px}</style>"
        descriptionTextView.attributedText = description.htmlToAttributedString
//        descriptionTextView.text = place.descriptionText
        accessFieldView.setData(title: "Access", value: place.access.joined(separator: ", "))
        priceDetailLabel.text = place.priceDetail
        toggleFieldView(contactFieldView, title: "Contact", value: place.contactName)
        toggleContactButtons(place)
    }
    
    /// Toggles display of views
    private func toggleFieldView(_ fieldView: FieldView, title: String, value: String?) {
        fieldView.isHidden = true
        guard let value = value else { return }
        fieldView.setData(title: title, value: value)
        fieldView.isHidden = false
    }
    
    /// Toggles display of contact buttons
    private func toggleContactButtons(_ place: Event) {
        let websiteUrl: String = place.accessLink ?? place.contactUrl ?? ""
        websiteButton.isHidden = websiteUrl.isEmpty ? true : false
        phoneButton.isHidden = place.contactPhone == nil ? true : false
        mailButton.isHidden = place.contactMail == nil ? true : false
    }
}

// MARK: - Constraints
extension EventStackView {
    
    /// Constrains the contact buttons
    private func constrainContactButtons() {
        [websiteButton, phoneButton, mailButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                $0.heightAnchor.constraint(equalToConstant: 50)
            ])
        }
    }
}
