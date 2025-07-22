//
//  EventDiscoveryService.swift
//  Evently-EventsExplorer
//
//  Created by Nanda WK on 2025-07-22.
//

import Foundation

protocol EventDiscoveryServiceProtocol {
    func load() async throws -> Events
}

struct EventDiscoveryService: EventDiscoveryServiceProtocol {
    let apiRepository: EventDiscoveryRepositoryProtocol

    func load() async throws -> Events {
        do {
            return try await apiRepository.events(with: .init())
        } catch {
            throw error
        }
    }
}

struct StubEventDiscoveryService: EventDiscoveryServiceProtocol {
    func load() async throws -> Events {
        .mockData
    }
}
