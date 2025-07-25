//
//  EventDiscoveryServiceTests.swift
//  Evently-EventsExplorerTests
//
//  Created by Nanda WK on 2025-07-25.
//

@testable import Evently_EventsExplorer
import XCTest

final class EventDiscoveryServiceTests: XCTestCase {
    var sut: EventDiscoveryService!
    var mockRepository: MockEventDiscoveryRepository!

    override func setUpWithError() throws {
        mockRepository = MockEventDiscoveryRepository()
        sut = EventDiscoveryService(apiRepository: mockRepository)
    }

    override func tearDownWithError() throws {
        sut = nil
        mockRepository = nil
    }

    func test_load_success() async throws {
        let expectedEvents = Events.mockData
        mockRepository.eventsResult = .success(expectedEvents)

        let events = try await sut.load(with: Filter())

        XCTAssertEqual(events, expectedEvents)
    }

    func test_load_failure_error() async {
        enum TestError: Error { case someError }
        mockRepository.eventsResult = .failure(TestError.someError)

        do {
            _ = try await sut.load(with: Filter())
            XCTFail("Expected error to be thrown, but got success")
        } catch let error as TestError {
            XCTAssertEqual(error, TestError.someError)
        } catch {
            XCTFail("Expected TestError, but got \(error)")
        }
    }

    func test_load_details_success() async throws {
        let expectedEvent = Event.mockData
        mockRepository.detailsResult = .success(expectedEvent)

        let event = try await sut.load(eventDetails: expectedEvent)

        XCTAssertEqual(event, expectedEvent)
    }

    func test_load_details_failure_error() async {
        enum TestError: Error { case someError }
        mockRepository.detailsResult = .failure(TestError.someError)

        do {
            _ = try await sut.load(eventDetails: .mockData)
            XCTFail("Expected error to be thrown, but got success")
        } catch let error as TestError {
            XCTAssertEqual(error, TestError.someError)
        } catch {
            XCTFail("Expected TestError, but got \(error)")
        }
    }
}
