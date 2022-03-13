//
//  EventCollectionViewCell.swift
//  ParisEnFamille
//
//  Created by Costa Monzili on 10/03/2022.
//  Copyright © 2022 Co5ta. All rights reserved.
//

import UIKit

class EventCollectionViewCell: UICollectionViewCell {
    
    func configure(with event: ListEvents.FetchEvents.ViewModel.Event) {
        guard let eventSampleView = UINib(nibName: "EventSampleView", bundle: nil)
                .instantiate(withOwner: nil, options: nil).first as? EventSampleView
        else { return }
        eventSampleView.configure(with: event)
        contentView.addSubview(eventSampleView)
        eventSampleView.frame = contentView.frame
    }
}
