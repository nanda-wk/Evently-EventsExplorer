//
//  EventDiscoveryService.swift
//  Evently-EventsExplorer
//
//  Created by Nanda WK on 2025-07-22.
//

import Foundation

protocol EventDiscoveryServiceProtocol {
    func load(with filter: Filter) async throws -> Events
    func load(eventDetails: Event) async throws -> Event
}

struct EventDiscoveryService: EventDiscoveryServiceProtocol {
    let apiRepository: EventDiscoveryRepositoryProtocol

    func load(with filter: Filter) async throws -> Events {
        try await apiRepository.events(with: filter)
    }

    func load(eventDetails: Event) async throws -> Event {
        try await apiRepository.eventDetails(event: eventDetails)
    }
}

struct StubEventDiscoveryService: EventDiscoveryServiceProtocol {
    func load(with _: Filter = Filter()) async throws -> Events {
        Events()
    }

    func load(eventDetails _: Event) async throws -> Event {
        Event()
    }
}
