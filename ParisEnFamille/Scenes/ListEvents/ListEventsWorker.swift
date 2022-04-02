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
    
    func fetchEvents() async throws -> [EventItem] {
        let eventItems = try await manager.fetchItems(of: EventItems.self)
        return eventItems.records
    }
}
