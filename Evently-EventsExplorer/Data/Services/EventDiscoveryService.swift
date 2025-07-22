//
//  EventDiscoveryService.swift
//  Evently-EventsExplorer
//
//  Created by Nanda WK on 2025-07-22.
//

import Foundation

protocol EventDiscoveryServiceProtocol {
    func load(with filter: Filter) async throws -> Events
}

struct EventDiscoveryService: EventDiscoveryServiceProtocol {
    let apiRepository: EventDiscoveryRepositoryProtocol

    func load(with filter: Filter) async throws -> Events {
        do {
            return try await apiRepository.events(with: filter)
        } catch {
            throw error
        }
    }
}

struct StubEventDiscoveryService: EventDiscoveryServiceProtocol {
    func load(with _: Filter = Filter()) async throws -> Events {
        .mockData
    }
}
