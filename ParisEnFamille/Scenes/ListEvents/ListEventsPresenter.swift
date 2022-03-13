//
//  ListEventsPresenter.swift
//  ParisEnFamille
//
//  Created by Costa Monzili on 27/02/2022.
//  Copyright © 2022 Co5ta. All rights reserved.
//
import Foundation

protocol ListEventsPresentationLogic {
    func present(response: ListEvents.FetchEvents.Response)
}

class ListEventsPresenter: ListEventsPresentationLogic {
    var viewController: ListEventsDisplayLogic?

    func present(response: ListEvents.FetchEvents.Response) {
        let formattedEvents = response.events.map {
            ListEvents.FetchEvents.ViewModel.Event(
                uuid: UUID(),
                title: $0.title ?? "",
                intro: $0.leadText,
                descriptionText: $0.descriptionText)
            }
        let viewModel = ListEvents.FetchEvents.ViewModel(events: formattedEvents)
        viewController?.displayEvents(viewModel: viewModel)
    }
}
