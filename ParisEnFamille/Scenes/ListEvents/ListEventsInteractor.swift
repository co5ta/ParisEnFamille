//
//  ListEventsInteractor.swift
//  ParisEnFamille
//
//  Created by Costa Monzili on 26/02/2022.
//  Copyright © 2022 Co5ta. All rights reserved.
//

protocol ListEventsBusinessLogic {
    func fetchEvents()
}

protocol ListEventsDataDource {
    var events: [Event] { get }
}

class ListEventsInteractor: ListEventsBusinessLogic, ListEventsDataDource {
    var presenter: ListEventsPresenter?
    var worker: ListEventsWorker = ListEventsWorker(manager: NetworkService())
    var events: [Event] = []

    func fetchEvents() {
        worker.fetchEvents(completionHandler: { result in
            switch result {
            case .failure(let error):
                print(error)
            case let .success(events):
                let response = ListEvents.FetchEvents.Response(events: events)
                self.presenter?.present(response: response)
            }
        })
    }
}
