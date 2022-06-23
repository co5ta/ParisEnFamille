//
//  ListEventsBusinessLogicSpy.swift
//  ParisEnFamilleTests
//
//  Created by costa.monzili on 18/06/2022.
//  Copyright © 2022 Co5ta. All rights reserved.
//

import Foundation
@testable import ParisEnFamille

class ListEventsBusinessLogicSpy: ListEventsBusinessLogic {
    var fetchEventsCalled = false
    
    func fetchEventItems() {
        fetchEventsCalled = true
    }
}
