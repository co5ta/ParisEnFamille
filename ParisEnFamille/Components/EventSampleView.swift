//
//  EventSampleView.swift
//  ParisEnFamille
//
//  Created by Costa Monzili on 10/03/2022.
//  Copyright © 2022 Co5ta. All rights reserved.
//

import UIKit

@IBDesignable
class EventSampleView: UIView {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var introLabel: UILabel!

    func configure(with event: ListEvents.FetchEvents.ViewModel.Event) {
        titleLabel.text = event.title
        introLabel.text = event.intro
    }
}
