//
//  ListEventsInteractorTests.swift
//  ParisEnFamilleTests
//
//  Created by costa.monzili on 23/06/2022.
//  Copyright © 2022 Co5ta. All rights reserved.
//

import XCTest
@testable import ParisEnFamille

class ListEventsInteractorTests: XCTestCase {
    
    var sut: ListEventsInteractor!

    override func setUpWithError() throws {
        sut = ListEventsInteractor()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func test_shouldCallFetchItemsAndCallPresentResponse() {
        let worker = ListEventsWorkerSpy(manager: NetworkService())
        let presenter = ListEventsPresentationLogicSpy()
        sut.worker = worker
        sut.presenter = presenter
        sut.fetchEventItems()
        XCTAssertTrue(worker.fetchEventsCalled)
        XCTAssertTrue(presenter.presentResponseCalled)
    }
}
