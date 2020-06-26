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
    /// Event date
    let dateFieldView = FieldView()
    /// A short text which describe the event
    let leadTextFieldView = FieldView()
    /// Indicates if the access is free or paying
    let accessFieldView = FieldView()
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
        addArrangedSubview(leadTextFieldView)
        addArrangedSubview(accessFieldView)
        addArrangedSubview(contactFieldView)
        setUpContactStackView()
        setUpContactButton(button: phoneButton, imageName: "phone")
        setUpContactButton(button: websiteButton, imageName: "safari")
        setUpContactButton(button: mailButton, imageName: "mail")
        constrainContactButtons()
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
        dateFieldView.setData(title: "Date", value: getDateText(place))
        leadTextFieldView.setData(title: "Description", value: place.leadText)
        var access = place.access.joined(separator: ", ")
        if let priceDetail = place.priceDetail { access += ":\n\(priceDetail)"}
        accessFieldView.setData(title: "Access", value: access)
        toggleFieldView(contactFieldView, title: "Contact", value: place.contactName)
        toggleContactButtons(place)
    }
    
    private func getDateText(_ place: Event) -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = .medium
        let dateStart = dateformatter.string(from: place.dateStart)
        let dateEnd = dateformatter.string(from: place.dateEnd)
        return dateStart != dateEnd ? "From \(dateStart) to \(dateEnd)" : dateStart
    }
    
    /// Toggles display of views
    private func toggleFieldView(_ fieldView: FieldView, title: String, value: String?) {
        guard let value = value else {
            fieldView.isHidden = true
            return
        }
        fieldView.setData(title: title, value: value)
        fieldView.isHidden = false
    }
    
    /// Toggles display of contact buttons
    private func toggleContactButtons(_ place: Event) {
        websiteButton.isHidden = place.accessLink == nil ? true : false
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
