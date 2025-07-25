
//
//  SearchViewModelTests.swift
//  Evently-EventsExplorerTests
//
//  Created by Nanda WK on 2025-07-25.
//

@testable import Evently_EventsExplorer
import XCTest

final class SearchViewModelTests: XCTestCase {
    var viewModel: SearchViewModel!
    var mockService: MockEventDiscoveryService!
    var container: DIContainer!

    private var testData: [Event] = (0 ..< 10).map { Event(id: "\($0)") }

    override func setUpWithError() throws {
        mockService = MockEventDiscoveryService()
        container = DIContainer(
            services: .init(eventDiscoveryService: mockService)
        )
        viewModel = SearchViewModel(container: container)
    }

    override func tearDownWithError() throws {
        viewModel = nil
        mockService = nil
        container = nil
    }

    func testInitialState() {
        XCTAssertTrue(viewModel.events.isEmpty)
        XCTAssertEqual(viewModel.keyword, "")
        XCTAssertEqual(viewModel.numberOfRows(), 0)
        XCTAssertFalse(viewModel.isFetching)
        XCTAssertTrue(viewModel.canLoadMore)
        XCTAssertFalse(viewModel.isEventListEmpty)
    }

    func testLoadEvents_success_firstPage() async throws {
        let mockEvents = testData
        let mockPage = Page(size: 10, totalElements: 20, totalPages: 1, number: 0)
        let mockEventsResponse = Events(embedded: .init(events: mockEvents), page: mockPage)
        mockService.loadResult = .success(mockEventsResponse)

        let expectation = XCTestExpectation(description: "onUpdate should be called twice")
        expectation.expectedFulfillmentCount = 2

        viewModel.onUpdate = {
            expectation.fulfill()
        }

        await viewModel.loadEvents()
        await fulfillment(of: [expectation], timeout: 1.0)

        XCTAssertFalse(viewModel.isFetching)
        XCTAssertEqual(viewModel.events.count, 10)
        XCTAssertEqual(viewModel.numberOfRows(), 10)
        XCTAssertEqual(viewModel.page, 1)
        XCTAssertEqual(viewModel.events, mockEvents)
        XCTAssertFalse(viewModel.canLoadMore)
        XCTAssertFalse(viewModel.isEventListEmpty)
    }

    func testLoadEvents_success_secondPage() async throws {
        let firstPageEvents = testData
        let secondPageEvents = testData.prefix(5).map(\.self)
        let firstMockPage = Page(size: 10, totalElements: 20, totalPages: 2, number: 0)
        let firstMockEventsResponse = Events(embedded: .init(events: firstPageEvents), page: firstMockPage)
        let secondMockPage = Page(size: 10, totalElements: 20, totalPages: 2, number: 1)
        let secondMockEventsResponse = Events(embedded: .init(events: secondPageEvents), page: secondMockPage)
        mockService.loadResult = .success(firstMockEventsResponse)

        let expectation1 = XCTestExpectation(description: "onUpdate should be called twice")
        expectation1.expectedFulfillmentCount = 2

        viewModel.onUpdate = {
            expectation1.fulfill()
        }

        await viewModel.loadEvents()
        await fulfillment(of: [expectation1], timeout: 1.0)
        XCTAssertFalse(viewModel.isFetching)
        XCTAssertEqual(viewModel.events.count, 10)
        XCTAssertEqual(viewModel.numberOfRows(), 10)
        XCTAssertEqual(viewModel.page, 1)
        XCTAssertEqual(viewModel.events, firstPageEvents)
        XCTAssertTrue(viewModel.canLoadMore)
        XCTAssertFalse(viewModel.isEventListEmpty)

        let expectation2 = XCTestExpectation(description: "onUpdate should be called twice")
        expectation2.expectedFulfillmentCount = 2

        viewModel.onUpdate = {
            expectation2.fulfill()
        }

        mockService.loadResult = .success(secondMockEventsResponse)

        await viewModel.loadEvents()
        await fulfillment(of: [expectation2], timeout: 1.0)
        XCTAssertFalse(viewModel.isFetching)
        XCTAssertEqual(viewModel.events.count, 15)
        XCTAssertEqual(viewModel.numberOfRows(), 15)
        XCTAssertEqual(viewModel.page, 2)
        XCTAssertEqual(viewModel.events, firstPageEvents + secondPageEvents)
        XCTAssertFalse(viewModel.canLoadMore)
        XCTAssertFalse(viewModel.isEventListEmpty)

        XCTAssertEqual(mockService.loadCallCount, 2)
    }

    func testLoadEvents_failure() async throws {
        enum TestError: Error, Equatable { case networkError }
        mockService.loadResult = .failure(TestError.networkError)

        let expectation = XCTestExpectation(description: "onUpdate should be called twice")
        expectation.expectedFulfillmentCount = 2

        viewModel.onUpdate = {
            expectation.fulfill()
        }

        await viewModel.loadEvents()
        await fulfillment(of: [expectation], timeout: 1.0)

        XCTAssertFalse(viewModel.isFetching)
        XCTAssertTrue(viewModel.events.isEmpty)
        XCTAssertEqual(viewModel.numberOfRows(), 0)
        XCTAssertEqual(viewModel.page, 0)
        XCTAssertTrue(viewModel.isEventListEmpty)
        XCTAssertTrue(viewModel.canLoadMore)
    }

    func testLoadEvents_reset() async throws {
        let firstPageEvents = testData
        let firstMockPage = Page(size: 10, totalElements: 20, totalPages: 1, number: 0)
        let firstMockEventsResponse = Events(embedded: .init(events: firstPageEvents), page: firstMockPage)
        mockService.loadResult = .success(firstMockEventsResponse)

        let expectation1 = XCTestExpectation(description: "onUpdate should be called twice")
        expectation1.expectedFulfillmentCount = 2

        viewModel.onUpdate = {
            expectation1.fulfill()
        }

        await viewModel.loadEvents()
        await fulfillment(of: [expectation1], timeout: 1.0)

        XCTAssertFalse(viewModel.isFetching)
        XCTAssertEqual(viewModel.events.count, 10)
        XCTAssertEqual(viewModel.numberOfRows(), 10)
        XCTAssertEqual(viewModel.events, firstPageEvents)
        XCTAssertEqual(viewModel.page, 1)
        XCTAssertFalse(viewModel.canLoadMore)
        XCTAssertFalse(viewModel.isEventListEmpty)

        mockService.loadResult = .success(Events(embedded: .init(events: firstPageEvents.prefix(5).map(\.self)), page: firstMockPage))

        let expectation2 = XCTestExpectation(description: "second expectation of onUpdate should be called twice")
        expectation2.expectedFulfillmentCount = 2

        viewModel.onUpdate = {
            expectation2.fulfill()
        }

        await viewModel.loadEvents(reset: true)
        await fulfillment(of: [expectation2], timeout: 1.0)

        XCTAssertFalse(viewModel.isFetching)
        XCTAssertEqual(viewModel.events.count, 5)
        XCTAssertEqual(viewModel.numberOfRows(), 5)
        XCTAssertEqual(viewModel.events, firstPageEvents.prefix(5).map(\.self))
        XCTAssertEqual(viewModel.page, 1)
        XCTAssertFalse(viewModel.canLoadMore)
        XCTAssertFalse(viewModel.isEventListEmpty)
        XCTAssertEqual(mockService.loadCallCount, 2)
    }

    func testLoadEvents_alreadyFetching() async {
        let mockEvents = testData
        let mockPage = Page(size: 10, totalElements: 20, totalPages: 1, number: 0)
        let mockEventsResponse = Events(embedded: .init(events: mockEvents), page: mockPage)
        mockService.loadResult = .success(mockEventsResponse)
        mockService.delay = 0.1 // Crucial: Simulate a network delay

        let firstFetchOnUpdateExpectation = XCTestExpectation(description: "First fetch onUpdate should be called twice")
        firstFetchOnUpdateExpectation.expectedFulfillmentCount = 2

        let secondFetchOnUpdateExpectation = XCTestExpectation(description: "Second fetch onUpdate should NOT be called")
        secondFetchOnUpdateExpectation.isInverted = true

        var onUpdateCallCount = 0
        viewModel.onUpdate = {
            onUpdateCallCount += 1
            if onUpdateCallCount <= 2 {
                firstFetchOnUpdateExpectation.fulfill()
            } else {
                secondFetchOnUpdateExpectation.fulfill()
            }
        }

        let task1 = Task { await viewModel.loadEvents() }
        let task2 = Task { await viewModel.loadEvents() }

        await task1.value
        await task2.value

        await fulfillment(of: [firstFetchOnUpdateExpectation, secondFetchOnUpdateExpectation], timeout: 1.0)

        XCTAssertEqual(mockService.loadCallCount, 1, "Service load should only be called once")
        XCTAssertFalse(viewModel.isFetching, "ViewModel should not be fetching after both tasks complete")
        XCTAssertEqual(viewModel.events.count, 10, "Events should contain data from the first fetch")
    }

    func testLoadEvents_isFetching_duringFetch() async {
        let mockEvents = testData
        let mockPage = Page(size: 10, totalElements: 20, totalPages: 1, number: 0)
        let mockEventsResponse = Events(embedded: .init(events: mockEvents), page: mockPage)
        mockService.loadResult = .success(mockEventsResponse)
        mockService.delay = 0.1

        let isFetchingExpectation = XCTestExpectation(description: "isFetching should be true during fetc")
        let expectation = XCTestExpectation(description: "onUpdate should be called twice")
        expectation.expectedFulfillmentCount = 2

        viewModel.onUpdate = {
            if self.viewModel.isFetching {
                isFetchingExpectation.fulfill()
            }
            expectation.fulfill()
        }

        let task = Task {
            await viewModel.loadEvents()
        }
        await fulfillment(of: [isFetchingExpectation], timeout: 0.05)
        XCTAssertTrue(viewModel.isFetching)

        await task.value
        await fulfillment(of: [expectation], timeout: 1.0)
        XCTAssertFalse(viewModel.isFetching)
    }

    func testLoadEvents_noMorePages() async {
        let mockEvents = testData
        let mockPage = Page(size: 10, totalElements: 20, totalPages: 1, number: 0)
        let mockEventsResponse = Events(embedded: .init(events: mockEvents), page: mockPage)
        mockService.loadResult = .success(mockEventsResponse)

        let expectation1 = XCTestExpectation(description: "onUpdate should be called twice")
        expectation1.expectedFulfillmentCount = 2

        viewModel.onUpdate = {
            expectation1.fulfill()
        }

        await viewModel.loadEvents()
        await fulfillment(of: [expectation1], timeout: 1.0)

        XCTAssertEqual(viewModel.events.count, 10)
        XCTAssertFalse(viewModel.canLoadMore)

        let expectation2 = XCTestExpectation(description: "onUpdate should not be called")
        expectation2.isInverted = true

        viewModel.onUpdate = {
            expectation2.fulfill()
        }

        await viewModel.loadEvents()
        await fulfillment(of: [expectation2], timeout: 1.0)

        XCTAssertEqual(viewModel.events.count, 10)
        XCTAssertFalse(viewModel.isFetching)
    }

    func testLoadEvents_emptyResults() async throws {
        let mockPage = Page(size: 10, totalElements: 20, totalPages: 1, number: 0)
        let mockEventsResponse = Events(embedded: nil, page: mockPage)
        mockService.loadResult = .success(mockEventsResponse)

        let expectation = XCTestExpectation(description: "onUpdate should be called twice")
        expectation.expectedFulfillmentCount = 2

        viewModel.onUpdate = {
            expectation.fulfill()
        }

        await viewModel.loadEvents()
        await fulfillment(of: [expectation], timeout: 1.0)

        XCTAssertFalse(viewModel.isFetching)
        XCTAssertTrue(viewModel.events.isEmpty)
        XCTAssertTrue(viewModel.isEventListEmpty)
        XCTAssertFalse(viewModel.canLoadMore)
    }

    func testLoadEvents_withKeyword() async throws {
        let mockEvents = testData
        let mockPage = Page(size: 10, totalElements: 20, totalPages: 1, number: 0)
        let mockEventsResponse = Events(embedded: .init(events: mockEvents), page: mockPage)
        mockService.loadResult = .success(mockEventsResponse)

        viewModel.keyword = "test_keyword"

        let expectation = XCTestExpectation(description: "onUpdate should be called twice")
        expectation.expectedFulfillmentCount = 2

        viewModel.onUpdate = {
            expectation.fulfill()
        }

        await viewModel.loadEvents()
        await fulfillment(of: [expectation], timeout: 1.0)

        XCTAssertFalse(viewModel.isFetching)
        XCTAssertEqual(viewModel.events.count, 10)
        XCTAssertEqual(viewModel.events, mockEvents)
        XCTAssertFalse(viewModel.isEventListEmpty)
    }

    func testResetFunction() async {
        let mockEvents = testData
        let mockPage = Page(size: 10, totalElements: 20, totalPages: 1, number: 0)
        let mockEventsResponse = Events(embedded: .init(events: mockEvents), page: mockPage)
        mockService.loadResult = .success(mockEventsResponse)

        let expectation = XCTestExpectation(description: "onUpdate should be called twice")
        expectation.expectedFulfillmentCount = 2

        viewModel.onUpdate = {
            expectation.fulfill()
        }

        await viewModel.loadEvents()
        await fulfillment(of: [expectation], timeout: 1.0)

        viewModel.keyword = "some_keyword"

        viewModel.reset()

        XCTAssertTrue(viewModel.events.isEmpty)
        XCTAssertEqual(viewModel.keyword, "some_keyword")
        XCTAssertEqual(viewModel.page, 0)
        XCTAssertFalse(viewModel.isFetching)
        XCTAssertTrue(viewModel.canLoadMore)
        XCTAssertFalse(viewModel.isEventListEmpty)
    }

    func testEventAtIndex() async {
        let mockEvents = testData
        let mockPage = Page(size: 10, totalElements: 20, totalPages: 1, number: 0)
        let mockEventsResponse = Events(embedded: .init(events: mockEvents), page: mockPage)
        mockService.loadResult = .success(mockEventsResponse)

        let expectation = XCTestExpectation(description: "onUpdate should be called twice")
        expectation.expectedFulfillmentCount = 2

        viewModel.onUpdate = {
            expectation.fulfill()
        }

        await viewModel.loadEvents()
        await fulfillment(of: [expectation], timeout: 1.0)

        XCTAssertEqual(viewModel.event(at: 0), mockEvents[0])
        XCTAssertEqual(viewModel.event(at: 1), mockEvents[1])
        XCTAssertEqual(viewModel.event(at: 2), mockEvents[2])
    }
}
