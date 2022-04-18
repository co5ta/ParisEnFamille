//
//  ListEventsInteractor.swift
//  ParisEnFamille
//
//  Created by Costa Monzili on 26/02/2022.
//  Copyright © 2022 Co5ta. All rights reserved.
//

protocol ListEventsBusinessLogic {
//    func fetchEvents()
    func fetchEventItems()
}

protocol ListEventsDataDource {
    var events: [EventItem] { get }
}

class ListEventsInteractor: ListEventsBusinessLogic, ListEventsDataDource {
    var presenter: ListEventsPresenter?
    var worker: ListEventsWorker = ListEventsWorker(manager: NetworkService())
    var events: [EventItem] = []
    
    func fetchEventItems() {
        Task {
            do {
                events = try await worker.fetchEvents()
                await presenter?.present(response: ListEvents.FetchEvents.Response(eventItems: events))
            } catch {
                print("🔴", error)
            }
        }
    }
}
