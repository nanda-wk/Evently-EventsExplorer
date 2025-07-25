//
//  MockEventDiscoveryRepository.swift
//  Evently-EventsExplorerTests
//
//  Created by Nanda WK on 2025-07-25.
//

@testable import Evently_EventsExplorer
import Foundation

class MockEventDiscoveryRepository: EventDiscoveryRepositoryProtocol {
    var session: URLSessionProtocol = URLSession.shared

    var eventsResult: Result<Events, Error>?
    var detailsResult: Result<Event, Error>?

    func events(with _: Filter) async throws -> Events {
        if let result = eventsResult {
            switch result {
            case let .success(events):
                return events
            case let .failure(error):
                throw error
            }
        }
        fatalError("eventsResult was not set")
    }

    func eventDetails(event _: Event) async throws -> Event {
        if let result = detailsResult {
            switch result {
            case let .success(event):
                return event
            case let .failure(error):
                throw error
            }
        }
        fatalError("detailsResult was not set")
    }
}
