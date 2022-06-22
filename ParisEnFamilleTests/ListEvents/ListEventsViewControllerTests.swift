//
//  ListEventsViewControllerTests.swift
//  ParisEnFamilleTests
//
//  Created by costa.monzili on 18/06/2022.
//  Copyright © 2022 Co5ta. All rights reserved.
//

import XCTest
@testable import ParisEnFamille

class ListEventsViewControllerTests: XCTestCase {
    
    var sut: ListEventsViewController!

    override func setUpWithError() throws {
        let storyboard = UIStoryboard(name: "ListEvents", bundle: nil)
        sut = try XCTUnwrap(storyboard.instantiateInitialViewController() as? ListEventsViewController)
        sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func test_shouldFetchEvents() {
        let listEventsBusinessLogicSpy = ListEventsBusinessLogicSpy()
        sut.interactor = listEventsBusinessLogicSpy
        
        let window = UIWindow()
        window.makeKeyAndVisible()
        window.rootViewController = sut
        
        XCTAssertTrue(listEventsBusinessLogicSpy.fetchEventsCalled)
    }
    
    func test_shouldHaveCollectionView() {
        XCTAssertTrue(sut.collectionView.isDescendant(of: sut.view))
    }
    
    func test_numberOfItems_whenOneEventFetched_shouldReturnOne() {
        let events = [
            ListEvents.FetchEvents.ViewModel.EventItem(
                uuid: UUID(), title: "dummy title", intro: "", coverUrl: "", tags: [])
            ]
        
        let viewModel = ListEvents.FetchEvents.ViewModel(events: events)
        sut.displayEvents(viewModel: viewModel)
        
        let result = sut.collectionView?.numberOfItems(inSection: 0)
        XCTAssertEqual(result, 1)
    }
    
    func test_numberOfItems_whenTwoEventFetched_shouldReturnTwo() {
        let events = [
            ListEvents.FetchEvents.ViewModel.EventItem(
                uuid: UUID(), title: "dummy title", intro: "", coverUrl: "", tags: []),
            ListEvents.FetchEvents.ViewModel.EventItem(
                uuid: UUID(), title: "dummy title", intro: "", coverUrl: "", tags: []),
            ]
        
        let viewModel = ListEvents.FetchEvents.ViewModel(events: events)
        sut.displayEvents(viewModel: viewModel)
        
        let result = sut.collectionView?.numberOfItems(inSection: 0)
        XCTAssertEqual(result, 2)
    }
    
    func test_cellForRowAt_shouldReturnTitle() throws {
        let expected = "dummy text"
        let events = [
            ListEvents.FetchEvents.ViewModel.EventItem(
                uuid: UUID(), title: expected, intro: "", coverUrl: "", tags: []),
            ]
        
        let viewModel = ListEvents.FetchEvents.ViewModel(events: events)
        sut.displayEvents(viewModel: viewModel)
        
        let indexPath = IndexPath(item: 0, section: 0)
        let cell = try XCTUnwrap(
            sut.collectionView.dataSource?.collectionView(sut.collectionView!, cellForItemAt: indexPath) as? EventCollectionViewCell)
        let eventSampleView = try XCTUnwrap(cell.contentView.subviews.first(where: { $0 is EventSampleView }) as? EventSampleView)
        
        let result = eventSampleView.titleLabel.text
        XCTAssertEqual(result, expected)
    }
    
    func test_cellForRowAt_shouldReturnIntro() throws {
        let expected = "dummy text"
        let events = [
            ListEvents.FetchEvents.ViewModel.EventItem(
                uuid: UUID(), title: "", intro: expected, coverUrl: "", tags: []),
            ]
        
        let viewModel = ListEvents.FetchEvents.ViewModel(events: events)
        sut.displayEvents(viewModel: viewModel)
        
        let indexPath = IndexPath(item: 0, section: 0)
        let cell = try XCTUnwrap(
            sut.collectionView.dataSource?.collectionView(sut.collectionView!, cellForItemAt: indexPath) as? EventCollectionViewCell)
        let eventSampleView = try XCTUnwrap(cell.contentView.subviews.first(where: { $0 is EventSampleView }) as? EventSampleView)
        
        let result = eventSampleView.introLabel.text
        XCTAssertEqual(result, expected)
    }
    
    func test_cellForRowAt_shouldReturnTags() throws {
        let tags = ["tag1", "tag2", "tag3"]
        let expected = ["#tag1", "#tag2", "#tag3"]
        let events = [
            ListEvents.FetchEvents.ViewModel.EventItem(
                uuid: UUID(), title: "", intro: "", coverUrl: "", tags: tags),
            ]
        let viewModel = ListEvents.FetchEvents.ViewModel(events: events)
        sut.displayEvents(viewModel: viewModel)
        
        let indexPath = IndexPath(item: 0, section: 0)
        let cell = try XCTUnwrap(
            sut.collectionView.dataSource?.collectionView(sut.collectionView!, cellForItemAt: indexPath) as? EventCollectionViewCell)
        let eventSampleView = try XCTUnwrap(cell.contentView.subviews.first(where: { $0 is EventSampleView }) as? EventSampleView)
        let tagsButton = try XCTUnwrap(eventSampleView.tagsStackView.subviews as? [UIButton])
        
        let result = tagsButton.compactMap { $0.titleLabel?.text }
        XCTAssertEqual(result, expected)
    }
}
