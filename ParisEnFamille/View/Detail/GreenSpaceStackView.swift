//
//  GreenSpaceDetailView.swift
//  ParisEnFamille
//
//  Created by co5ta on 04/06/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//

import UIKit
import MapKit

/// A stack view which contains the details about a greenspace
class GreenSpaceStackView: UIStackView {
    
    /// Address of the greenspace
    let addressFieldView = FieldView()
    /// Surface of the greenspace
    let surfaceFieldView = FieldView()
    /// Horticultural surface of the greenspace
    let surfaceHortiFieldView = FieldView()
    /// Tells if the greenspace has fence
    let fenceFieldView = FieldView()
    /// Tells if the greenspace is open 2H hours a day
    let open24hFieldView = FieldView()
    /// Indicates if the opening year of the greenspace
    let anneeOuvertureFieldView = FieldView()
    /// Data of the greenspace
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
extension GreenSpaceStackView {
    
    /// Sets up the views
    private func setUpViews() {
        axis = .vertical
        addArrangedSubview(addressFieldView)
        addArrangedSubview(surfaceFieldView)
        addArrangedSubview(surfaceHortiFieldView)
        addArrangedSubview(fenceFieldView)
        addArrangedSubview(open24hFieldView)
        addArrangedSubview(anneeOuvertureFieldView)
    }
    
    /// Puts data in views
    private func setUpData(with place: Place?) {
        guard let place = place as? GreenSpace else { return }
        addressFieldView.setData(title: Strings.address, value: place.address, separatorHidden: true)
        surfaceFieldView.setData(title: Strings.surface, value: GreenSpace.getFormattedSurface(surface: place.surface))
        surfaceHortiFieldView.setData(title: Strings.horticulturalSurface, value: GreenSpace.getFormattedSurface(surface: place.horticulture))
        fenceFieldView.setData(title: Strings.fence, value: place.fence)
        open24hFieldView.setData(title: Strings.open24H, value: place.open24h)
        anneeOuvertureFieldView.setData(title: Strings.openingYear, value: place.openingYear)
    }
}
