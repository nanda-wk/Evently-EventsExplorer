//
//  MockEventDiscoveryRepository.swift
//  Evently-EventsExplorerTests
//
//  Created by Nanda WK on 2025-07-25.
//

@testable import Evently_EventsExplorer
import Foundation

class MockEventDiscoveryRepository: EventDiscoveryRepositoryProtocol {
    var session: URLSession = .shared

    var eventsResult: Result<Events, Error>?

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
}
