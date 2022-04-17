//
//  ListEventsPresenter.swift
//  ParisEnFamille
//
//  Created by Costa Monzili on 27/02/2022.
//  Copyright © 2022 Co5ta. All rights reserved.
//
import Foundation

protocol ListEventsPresentationLogic {
    func present(response: ListEvents.FetchEvents.Response) async
}

@MainActor
class ListEventsPresenter: ListEventsPresentationLogic {
    var viewController: ListEventsDisplayLogic?

    func present(response: ListEvents.FetchEvents.Response) async {
        let formattedEvents = response.eventItems.map {
            ListEvents.FetchEvents.ViewModel.EventItem(
                uuid: UUID(),
                title: $0.title,
                intro: $0.subtitle,
                descriptionText: $0.description,
                coverUrl: $0.coverUrl,
                tags: $0.tags.split(separator: ";").map {String($0)}
            )
        }
        let viewModel = ListEvents.FetchEvents.ViewModel(events: formattedEvents)
        viewController?.displayEvents(viewModel: viewModel)
    }
}
