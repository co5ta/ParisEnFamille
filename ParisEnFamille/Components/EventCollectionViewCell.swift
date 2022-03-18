//
//  EventCollectionViewCell.swift
//  ParisEnFamille
//
//  Created by Costa Monzili on 10/03/2022.
//  Copyright © 2022 Co5ta. All rights reserved.
//

import UIKit

class EventCollectionViewCell: UICollectionViewCell {
    override func prepareForReuse() {
        contentView.subviews.forEach { $0.removeFromSuperview() }
    }
    
    func configure(with event: ListEvents.FetchEvents.ViewModel.Event) {
        guard let eventSampleView = EventSampleView.fromNib else { return }
        eventSampleView.configure(with: event, imageLoader: ImageLoader())
        contentView.addSubview(eventSampleView)
        eventSampleView.frame = contentView.frame
    }
}
