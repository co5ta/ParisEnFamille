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

// MARK: - Setup
extension EventStackView {
    
    private func setUpViews() {
        axis = .vertical
        addArrangedSubview(addressFieldView)
        addArrangedSubview(dateFieldView)
        addArrangedSubview(leadTextFieldView)
        addArrangedSubview(accessFieldView)
        addArrangedSubview(contactFieldView)
        setUpContactStackView()
        configureContactButton(button: phoneButton, imageName: "phone")
        configureContactButton(button: websiteButton, imageName: "safari")
        configureContactButton(button: mailButton, imageName: "mail")
        constrainContactButtons()
    }
    
    private func setUpContactStackView() {
        contactStackView.spacing = 10
        contactStackView.distribution = .fillEqually
        setCustomSpacing(10, after: contactFieldView)
        addArrangedSubview(contactStackView)
    }
    
    private func configureContactButton(button: UIButton, imageName: String) {
        button.backgroundColor = Config.appGray
        button.setImage(UIImage(named: imageName), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.contentEdgeInsets = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        button.layer.cornerRadius = 5
        contactStackView.addArrangedSubview(button)
    }
}

// MARK: - Constraints
extension EventStackView {
    private func constrainContactButtons() {
        [websiteButton, phoneButton, mailButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                $0.heightAnchor.constraint(equalToConstant: 50)
            ])
        }
    }
}

// MARK: - Data
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
