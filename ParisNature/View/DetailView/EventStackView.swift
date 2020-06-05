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
    }
}

extension EventStackView {
    
    private func setUpData(with place: Place?) {
        guard let place = place as? Event else { return }
        addressFieldView.setData(title: "Address", value: place.address, separatorHidden: true)
        
        let date = getDateText(place)
        dateFieldView.setData(title: "Date", value: date)
        
        leadTextFieldView.setData(title: "Description", value: place.leadText)
        
        if place.access.isEmpty == false {
            accessFieldView.setData(title: "Access", value: place.access.joined(separator: ", "))
        }
    }
    
    private func getDateText(_ place: Event) -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = .medium
        let dateStart = dateformatter.string(from: place.dateStart)
        let dateEnd = dateformatter.string(from: place.dateEnd)
        return dateStart != dateEnd ? "from \(dateStart) to \(dateEnd)" : dateStart
    }
}
