//
//  ListEventsWorker.swift
//  ParisEnFamille
//
//  Created by Costa Monzili on 27/02/2022.
//  Copyright © 2022 Co5ta. All rights reserved.
//

import Foundation

class ListEventsWorker {
    let manager: NetworkService

    init(manager: NetworkService) {
        self.manager = manager
    }
    
    func fetchEvents(completionHandler: @escaping(Result<[Event], NetworkError>) -> Void) {
        manager.getPlaces(placeType: .activity, dataType: EventsResult.self) { result in
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
            case .success(let eventsData):
                completionHandler(.success(eventsData.records))
            }
        }
    }
}
