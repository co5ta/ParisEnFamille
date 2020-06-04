//
//  GreenSpaceDetailView.swift
//  ParisNature
//
//  Created by co5ta on 04/06/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//

import UIKit
import MapKit

class GreenSpaceStackView: UIStackView {
    
    var place: Place? { didSet {setUpData(with: place)} }
    let addressFieldView = FieldView()
    let surfaceLabel = FieldView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
        setUpViews()
    }
}

extension GreenSpaceStackView {
    
    private func setUpViews() {
        axis = .vertical
        addArrangedSubview(addressFieldView)
        addArrangedSubview(surfaceLabel)
    }
}

extension GreenSpaceStackView {
    
    private func setUpData(with place: Place?) {
        guard let place = place as? GreenSpace else { return }
        addressFieldView.setData(title: "Address", value: place.address, separatorHidden: true)
        
        if let surface = place.surface {
            let formatter = MKDistanceFormatter()
            formatter.units = .metric
            let surfaceFormatted = formatter.string(fromDistance: formatter.distance(from: "\(surface) m"))
            surfaceLabel.setData(title: "Surface", value: "\(surfaceFormatted)²")
            surfaceLabel.isHidden = false
        } else {
            surfaceLabel.isHidden = true
        }
    }
}
