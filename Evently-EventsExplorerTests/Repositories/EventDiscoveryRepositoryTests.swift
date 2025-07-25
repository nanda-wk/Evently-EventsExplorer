//
//  EventDiscoveryRepositoryTests.swift
//  Evently-EventsExplorerTests
//
//  Created by Nanda WK on 2025-07-25.
//

@testable import Evently_EventsExplorer
import XCTest

final class EventDiscoveryRepositoryTests: XCTestCase {
    var sut: EventDiscoveryRepository!
    var mockSession: MockURLSession!

    override func setUpWithError() throws {
        mockSession = MockURLSession()
        sut = EventDiscoveryRepository(session: mockSession)
    }

    override func tearDownWithError() throws {
        sut = nil
        mockSession = nil
    }

    func test_events_success() async throws {
        let expectedEvents = Events.mockData
        let jsonData = try JSONEncoder().encode(expectedEvents)
        mockSession.data = jsonData
        mockSession.response = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)

        let filter = Filter(keyword: "test", page: 1)

        let fetchedEvents = try await sut.events(with: filter)

        XCTAssertEqual(fetchedEvents, expectedEvents)
        XCTAssertNotNil(mockSession.lastRequest)
        XCTAssertEqual(mockSession.lastRequest?.url?.path, "/discovery/v2/events")

        XCTAssertEqual(mockSession.lastRequest?.httpMethod, "GET")

        let urlComponents = URLComponents(url: mockSession.lastRequest!.url!, resolvingAgainstBaseURL: false)
        let queryItems = urlComponents?.queryItems
        XCTAssertTrue(queryItems?.contains(where: { $0.name == "keyword" && $0.value == "test" }) ?? false)
        XCTAssertTrue(queryItems?.contains(where: { $0.name == "page" && $0.value == "1" }) ?? false)
        XCTAssertTrue(queryItems?.contains(where: { $0.name == "apikey" }) ?? false)
    }

    func test_events_failure_invalidURL() async {
        mockSession.error = NetworkError.invalidURL

        do {
            _ = try await sut.events(with: Filter())
            XCTFail("Expected NetworkError.invalidURL to be thrown, but got success")
        } catch let error as NetworkError {
            XCTAssertEqual(error, NetworkError.invalidURL)
        } catch {
            XCTFail("Expected NetworkError, but got unexpected error type: \(error)")
        }
    }

    func test_events_failure_httpCode() async {
        mockSession.data = Data()
        mockSession.response = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 404, httpVersion: nil, headerFields: nil)

        do {
            _ = try await sut.events(with: Filter())
            XCTFail("Expected NetworkError.httpCode to be thrown, but got success")
        } catch let error as NetworkError {
            XCTAssertEqual(error, NetworkError.httpCode(404))
        } catch {
            XCTFail("Expected NetworkError, but got unexpected error type: \(error)")
        }
    }

    func test_events_failure_invalidDecoding() async {
        let invalidJsonData = #"{"invalid": "json"}"#.data(using: .utf8)!
        mockSession.data = invalidJsonData
        mockSession.response = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)

        do {
            _ = try await sut.events(with: Filter())
            XCTFail("Expected NetworkError.invalidDecoding to be thrown, but got success")
        } catch let error as NetworkError {
            if case .invalidDecoding = error {
                XCTAssert(true, "Caught expected NetworkError.invalidDecoding")
            } else {
                XCTFail("Expected NetworkError.invalidDecoding, but got \(error)")
            }
        } catch {
            XCTFail("Expected NetworkError, but got unexpected error type: \(error)")
        }
    }

    func test_events_failure_unexpectedResponse() async {
        mockSession.data = Data()
        mockSession.response = URLResponse(url: URL(string: "https://example.com")!, mimeType: nil, expectedContentLength: 0, textEncodingName: nil)

        do {
            _ = try await sut.events(with: Filter())
            XCTFail("Expected NetworkError.unexpectedResponse to be thrown, but got success")
        } catch let error as NetworkError {
            XCTAssertEqual(error, NetworkError.unexpectedResponse)
        } catch {
            XCTFail("Expected NetworkError, but got unexpected error type: \(error)")
        }
    }
}
