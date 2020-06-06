//
//  EventStackView.swift
//  ParisNature
//
//  Created by co5ta on 05/06/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//

import UIKit

class EventStackView: UIStackView {

    var place: Place? { didSet {setUpData(with: place)} }
    let addressFieldView = FieldView()
    let dateFieldView = FieldView()
    let leadTextFieldView = FieldView()
    let accessFieldView = FieldView()
    let contactFieldView = FieldView()
    let contactStackView = UIStackView()
    let websiteButton = UIButton(type: .system)
    let phoneButton = UIButton(type: .system)
    let mailButton = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
        setUpViews()
    }
}

extension EventStackView {
    
    private func setUpViews() {
        axis = .vertical
        addArrangedSubview(addressFieldView)
        addArrangedSubview(dateFieldView)
        addArrangedSubview(leadTextFieldView)
        addArrangedSubview(accessFieldView)
        addArrangedSubview(contactFieldView)
        setUpContactStackView()
        setUpWebsiteButton()
        setUpPhoneButton()
        setUpMailButton()
    }
    
    private func setUpContactStackView() {
        contactStackView.spacing = 10
        contactStackView.distribution = .fillEqually
        addArrangedSubview(contactStackView)
    }
    
    private func setUpWebsiteButton() {
        websiteButton.backgroundColor = .lightGray
        websiteButton.setTitle("Website", for: .normal)
        websiteButton.layer.cornerRadius = 5
        contactStackView.addArrangedSubview(websiteButton)
    }
    
    private func setUpPhoneButton() {
        phoneButton.backgroundColor = .lightGray
        phoneButton.setTitle("Call", for: .normal)
        phoneButton.layer.cornerRadius = 5
        contactStackView.addArrangedSubview(phoneButton)
    }
    
    private func setUpMailButton() {
        mailButton.backgroundColor = .lightGray
        mailButton.setTitle("Mail", for: .normal)
        mailButton.layer.cornerRadius = 5
        contactStackView.addArrangedSubview(mailButton)
    }
}

extension EventStackView {
    
    private func setUpData(with place: Place?) {
        guard let place = place as? Event else { return }
        addressFieldView.setData(title: "Address", value: place.address, separatorHidden: true)
        dateFieldView.setData(title: "Date", value: getDateText(place))
        leadTextFieldView.setData(title: "Description", value: place.leadText)
        accessFieldView.setData(title: "Access", value: place.access.joined(separator: ", "))
        toggle(fieldView: contactFieldView, title: "Contact", value: place.contactName)
        toggleContactButtons(place)
    }
    
    private func getDateText(_ place: Event) -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = .medium
        let dateStart = dateformatter.string(from: place.dateStart)
        let dateEnd = dateformatter.string(from: place.dateEnd)
        return dateStart != dateEnd ? "From \(dateStart) to \(dateEnd)" : dateStart
    }
    
    private func toggle(fieldView: FieldView, title: String, value: String?) {
        guard let value = value else {
            fieldView.isHidden = true
            return
        }
        fieldView.setData(title: title, value: value)
        fieldView.isHidden = false
    }
    
    private func toggleContactButtons(_ place: Event) {
        websiteButton.isHidden = place.contactUrl == nil ? true : false
        phoneButton.isHidden = place.contactPhone == nil ? true : false
        mailButton.isHidden = place.contactMail == nil ? true : false
    }
}
