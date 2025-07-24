//
//  MockEventDiscoveryService.swift
//  Evently-EventsExplorerTests
//
//  Created by Nanda WK on 2025-07-25.
//

@testable import Evently_EventsExplorer
import Foundation

class MockEventDiscoveryService: EventDiscoveryServiceProtocol {
    var loadResult: Result<Events, Error>?
    var loadCallCount = 0
    var receivedFilter: Filter?

    func load(with filter: Filter) async throws -> Events {
        loadCallCount += 1
        receivedFilter = filter
        if let result = loadResult {
            switch result {
            case let .success(events):
                return events
            case let .failure(error):
                throw error
            }
        }
        fatalError("loadResult not set for MockEventDiscoveryService")
    }
}
