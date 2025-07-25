//
//  HomeViewModelTests.swift
//  Evently-EventsExplorerTests
//
//  Created by Nanda WK on 2025-07-25.
//

import Combine
@testable import Evently_EventsExplorer
import XCTest

@MainActor
final class HomeViewModelTests: XCTestCase {
    var sut: Home.ViewModel!
    var mockService: MockEventDiscoveryService!
    var diContainer: DIContainer!
    var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        mockService = MockEventDiscoveryService()

        diContainer = DIContainer(
            services: .init(eventDiscoveryService: mockService)
        )

        sut = Home.ViewModel(container: diContainer)
        cancellables = []
    }

    override func tearDownWithError() throws {
        sut = nil
        mockService = nil
        diContainer = nil
        cancellables = nil
    }

    func testInitialState() {
        XCTAssertEqual(sut.events, .isLoading)
        XCTAssertTrue(sut.shouldLoadMore)
        XCTAssertFalse(sut.isLoadingMore)
        XCTAssertTrue(sut.allEvents.isEmpty)
        XCTAssertEqual(sut.page, 0)
    }

    func testLoadEvents_initialLoad_success() async throws {
        let mockEvents = [Event.mockData, Event.mockData]
        let mockPage = Page(size: 2, totalElements: 2, totalPages: 1, number: 0)
        let mockEventsResponse = Events(embedded: .init(events: mockEvents), page: mockPage)
        mockService.loadResult = .success(mockEventsResponse)

        let expectation = XCTestExpectation(description: "Events loaded")

        sut.$events
            .dropFirst()
            .sink { loadableEvents in
                if case let .loaded(events) = loadableEvents {
                    XCTAssertEqual(events.count, mockEvents.count, "Should load the correct number of events")
                    XCTAssertEqual(self.sut.shouldLoadMore, false, "Should not load more if totalPages is 1")
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        await sut.loadEvents()

        await fulfillment(of: [expectation], timeout: 1.0)
        XCTAssertEqual(mockService.loadCallCount, 1, "load should be called once")
        XCTAssertEqual(mockService.receivedFilter?.page, 0, "Initial load should request page 0")
    }

    func testLoadEvents_initialLoad_failure() async throws {
        enum TestError: Error, Equatable { case networkError }
        mockService.loadResult = .failure(TestError.networkError)

        let expectation = XCTestExpectation(description: "Failed to load events")

        sut.$events
            .dropFirst()
            .sink { loadableEvents in
                if case let .failed(error as TestError) = loadableEvents {
                    XCTAssertEqual(error, .networkError)
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        await sut.loadEvents()

        await fulfillment(of: [expectation], timeout: 1.0)
        XCTAssertEqual(mockService.loadCallCount, 1, "load should be called once")
    }

    func testLoadEvents_loadMore_success() async throws {
        let page1Events = [Event.mockData]
        let page1 = Page(size: 1, totalElements: 3, totalPages: 2, number: 0)
        let response1 = Events(embedded: .init(events: page1Events), page: page1)
        mockService.loadResult = .success(response1)
        mockService.delay = 0.1

        let expectation1 = XCTestExpectation(description: "Initial page loaded")

        sut.$events
            .dropFirst()
            .sink { state in
                if case let .loaded(events) = state, events.count == 1 {
                    XCTAssertTrue(self.sut.shouldLoadMore)
                    expectation1.fulfill()
                }
            }
            .store(in: &cancellables)

        await sut.loadEvents()
        await fulfillment(of: [expectation1], timeout: 0.05)

        let page2Events = [Event(id: "2"), Event(id: "3")]
        let page2 = Page(size: 2, totalElements: 3, totalPages: 2, number: 1)
        let response2 = Events(embedded: .init(events: page2Events), page: page2)
        mockService.loadResult = .success(response2)

        let expectation2 = XCTestExpectation(description: "More events loaded")

        sut.$events
            .dropFirst()
            .sink { state in
                if case let .loaded(events) = state, events.count == 3 {
                    XCTAssertEqual(events.count, page1Events.count + page2Events.count, "Should have combined events")
                    XCTAssertEqual(self.sut.allEvents, page1Events + page2Events)
                    XCTAssertFalse(self.sut.shouldLoadMore)
                    expectation2.fulfill()
                }
            }
            .store(in: &cancellables)

        await sut.loadEvents()
        await fulfillment(of: [expectation2], timeout: 1.0)

        XCTAssertEqual(sut.shouldLoadMore, false, "Should not load more if totalPages is reached")
        XCTAssertEqual(mockService.loadCallCount, 2, "load should be called more than once for load more")
        XCTAssertEqual(mockService.receivedFilter?.page, 1, "Load more should request page 1")
    }

    func testLoadEvents_emptyResultsSetsShouldLoadMoreToFalse() async throws {
        let mockPage = Page(size: 0, totalElements: 0, totalPages: 0, number: 0)
        let mockEventsResponse = Events(embedded: nil, page: mockPage)
        mockService.loadResult = .success(mockEventsResponse)

        let expectation = XCTestExpectation(description: "Events loaded as empty")

        sut.$events
            .dropFirst()
            .sink { loadableEvents in
                if case let .loaded(events) = loadableEvents {
                    XCTAssertTrue(events.isEmpty)
                    XCTAssertFalse(self.sut.shouldLoadMore)
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        await sut.loadEvents()

        await fulfillment(of: [expectation], timeout: 1.0)
        XCTAssertEqual(mockService.loadCallCount, 1)
        XCTAssertEqual(sut.allEvents.count, 0)
    }

    func testLoadEvents_resetFunctionality() async throws {
        let initialEvents = [Event.mockData]
        let initialPage = Page(size: 1, totalElements: 3, totalPages: 2, number: 0)
        let initialResponse = Events(embedded: .init(events: initialEvents), page: initialPage)
        mockService.loadResult = .success(initialResponse)

        let expectation1 = XCTestExpectation(description: "Initial load")

        sut.$events
            .dropFirst()
            .sink { loadableEvents in
                if case let .loaded(events) = loadableEvents, events.count == 1 {
                    expectation1.fulfill()
                }
            }
            .store(in: &cancellables)

        await sut.loadEvents()
        await fulfillment(of: [expectation1], timeout: 1.0)

        let newEvents = [Event.mockData, Event.mockData, Event.mockData]
        let newPage = Page(size: 3, totalElements: 3, totalPages: 1, number: 0)
        let newResponse = Events(embedded: .init(events: newEvents), page: newPage)
        mockService.loadResult = .success(newResponse)

        let expectation2 = XCTestExpectation(description: "Events reset and reloaded")

        sut.$events
            .dropFirst()
            .sink { loadableEvents in
                if case let .loaded(events) = loadableEvents, events.count == 3 {
                    XCTAssertEqual(events.count, newEvents.count, "Should have only new events after reset")
                    XCTAssertEqual(self.sut.allEvents, newEvents)
                    expectation2.fulfill()
                }
            }
            .store(in: &cancellables)

        await sut.loadEvents(reset: true)
        await fulfillment(of: [expectation2], timeout: 1.0)

        XCTAssertEqual(sut.shouldLoadMore, false, "Should not load more if totalPages is 1")
        XCTAssertEqual(mockService.loadCallCount, 2, "load should be called once after reset")
        XCTAssertEqual(mockService.receivedFilter?.page, 0, "Reset should request page 0")
    }

    func testLoadEvents_doesNotLoadIfAlreadyLoading() async throws {
        let mockEvents = [Event.mockData]
        let mockPage = Page(size: 1, totalElements: 1, totalPages: 1, number: 0)
        let mockEventsResponse = Events(embedded: .init(events: mockEvents), page: mockPage)
        mockService.loadResult = .success(mockEventsResponse)
        mockService.delay = 0.1

        let firstLoadExpectation = XCTestExpectation(description: "First load should complete")
        sut.$events
            .dropFirst()
            .sink { loadableEvents in
                if case .loaded = loadableEvents {
                    firstLoadExpectation.fulfill()
                }
            }
            .store(in: &cancellables)

        let task1 = Task { await sut.loadEvents() }
        let task2 = Task { await sut.loadEvents() }

        await task1.value
        await task2.value

        await fulfillment(of: [firstLoadExpectation], timeout: 1.0)

        XCTAssertEqual(mockService.loadCallCount, 1, "load should be called once after first call")
        XCTAssertEqual(sut.isLoadingMore, false, "load should not be called again if already loading")
        XCTAssertEqual(sut.allEvents.count, 1, "Events should contain data from the first fetch")
    }
}
