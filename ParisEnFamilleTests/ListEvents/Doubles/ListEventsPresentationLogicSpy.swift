//
//  ListEventsPresentationLogicSpy.swift
//  ParisEnFamilleTests
//
//  Created by costa.monzili on 23/06/2022.
//  Copyright © 2022 Co5ta. All rights reserved.
//

import Foundation
@testable import ParisEnFamille

class ListEventsPresentationLogicSpy: ListEventsPresentationLogic {
    var presentResponseCalled = false
    
    func present(response: ListEvents.FetchEvents.Response) async {
        presentResponseCalled = true
    }
}
