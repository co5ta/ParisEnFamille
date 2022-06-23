//
//  ListEventsWorkerSpy.swift
//  ParisEnFamilleTests
//
//  Created by costa.monzili on 23/06/2022.
//  Copyright © 2022 Co5ta. All rights reserved.
//

import Foundation
@testable import ParisEnFamille

class ListEventsWorkerSpy: ListEventsWorker {
    var fetchEventsCalled = false
    
    override func fetchEvents() async throws -> [EventItem] {
        fetchEventsCalled = true
        return []
    }
}
