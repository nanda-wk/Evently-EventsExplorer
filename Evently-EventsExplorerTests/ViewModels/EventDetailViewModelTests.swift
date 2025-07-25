//
//  EventDetailViewModelTests.swift
//  Evently-EventsExplorerTests
//
//  Created by Nanda WK on 2025-07-25.
//

import Combine
@testable import Evently_EventsExplorer
import XCTest

@MainActor
final class EventDetailViewModelTests: XCTestCase {
    var sut: EventDetail.ViewModel!
    var mockService: MockEventDiscoveryService!
    var diContainer: DIContainer!
    var cancelables: Set<AnyCancellable>!
    var testEventData: Event = .mockData

    override func setUpWithError() throws {
        mockService = MockEventDiscoveryService()
        diContainer = DIContainer(services: .init(eventDiscoveryService: mockService))
        sut = .init(container: diContainer, event: testEventData)
        cancelables = []
    }

    override func tearDownWithError() throws {
        sut = nil
        mockService = nil
        diContainer = nil
        cancelables = nil
    }

    func testInitialState() {
        XCTAssertEqual(sut.details, .isLoading)
        XCTAssertTrue(sut.date.isEmpty)
        XCTAssertTrue(sut.time.isEmpty)
        XCTAssertTrue(sut.address.isEmpty)
        XCTAssertEqual(sut.venue, .init())
        XCTAssertEqual(sut.event, testEventData)
    }

    func testLoadDetails_initialLoad_success() async throws {
        let expected = testEventData
        mockService.loadDetails = .success(expected)

        let exp = XCTestExpectation(description: "Event loaded")

        sut.$details
            .dropFirst()
            .sink { loadableDetails in
                if case let .loaded(event) = loadableDetails {
                    XCTAssertEqual(event, expected)
                    exp.fulfill()
                }
            }
            .store(in: &cancelables)

        await sut.loadEventDetails()
        await fulfillment(of: [exp], timeout: 1.0)

        XCTAssertEqual(mockService.loadCallCount, 1)
    }

    func testLoadDetails_initialLoad_failure() async throws {
        enum TestError: Error, Equatable { case networkError }
        mockService.loadDetails = .failure(TestError.networkError)

        let exp = XCTestExpectation(description: "Failed to load details")

        sut.$details
            .dropFirst()
            .sink { loadableDetails in
                if case let .failed(error as TestError) = loadableDetails {
                    XCTAssertEqual(error, .networkError)
                    exp.fulfill()
                }
            }
            .store(in: &cancelables)

        await sut.loadEventDetails()

        await fulfillment(of: [exp], timeout: 1.0)
        XCTAssertEqual(mockService.loadCallCount, 1)
    }
}
