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
    let surfaceFieldView = FieldView()
    let surfaceHortiFieldView = FieldView()
    let fenceFieldView = FieldView()
    let open24hFieldView = FieldView()
    let anneeOuvertureFieldView = FieldView()

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
        addArrangedSubview(surfaceFieldView)
        addArrangedSubview(surfaceHortiFieldView)
        addArrangedSubview(fenceFieldView)
        addArrangedSubview(open24hFieldView)
        addArrangedSubview(anneeOuvertureFieldView)
    }
}

extension GreenSpaceStackView {
    
    private func setUpData(with place: Place?) {
        guard let place = place as? GreenSpace else { return }
        addressFieldView.setData(title: "Address", value: place.address, separatorHidden: true)
        surfaceFieldView.setData(title: "Surface", value: GreenSpace.getFormattedSurface(surface: place.surface))
        surfaceHortiFieldView.setData(title: "Horticultural surface", value: GreenSpace.getFormattedSurface(surface: place.horticulture))
        fenceFieldView.setData(title: "Fence", value: place.fence)
        open24hFieldView.setData(title: "Open 24H a day", value: place.open24h)
        anneeOuvertureFieldView.setData(title: "Opening year", value: place.openingYear)
    }
}
