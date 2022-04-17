//
//  EventSampleView.swift
//  ParisEnFamille
//
//  Created by Costa Monzili on 10/03/2022.
//  Copyright © 2022 Co5ta. All rights reserved.
//

import UIKit

class EventSampleView: UIView {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var introLabel: UILabel!
    @IBOutlet private weak var tagsStackView: UIStackView!
    
    /// Configures the view with the event data
    /// - Parameters:
    ///     - event: event data
    ///     - imageLoader: event image loader
    func configure(with event: ListEvents.FetchEvents.ViewModel.EventItem, imageLoader: AnyImageLoader) {
        imageLoader.load(image: event.coverUrl, into: imageView)
        titleLabel.text = event.title
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        introLabel.text = event.intro
        introLabel.font = UIFont.preferredFont(forTextStyle: .callout)
        tagsStackView.spacing = 10
        add(tags: event.tags)
    }
    
    /// Adds tags of the event
    /// - Parameter event: event tags
    private func add(tags: [String]) {
        for tag in tags {
            var config = UIButton.Configuration.tinted()
            config.buttonSize = .mini
            config.title = "#\(tag)"
            let button = UIButton(configuration: config)
            tagsStackView.addArrangedSubview(button)
        }
    }
}
