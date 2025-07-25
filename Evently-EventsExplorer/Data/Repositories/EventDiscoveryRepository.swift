//
//  EventDiscoveryRepository.swift
//  Evently-EventsExplorer
//
//  Created by Nanda WK on 2025-07-22.
//

import Foundation

protocol EventDiscoveryRepositoryProtocol: NetworkProtocol {
    func events(with filter: Filter) async throws -> Events
    func eventDetails(event: Event) async throws -> Event
}

struct EventDiscoveryRepository: EventDiscoveryRepositoryProtocol {
    var session: URLSessionProtocol

    func events(with filter: Filter) async throws -> Events {
        try await request(requestConfiguration: API.events(filter: filter))
    }

    func eventDetails(event: Event) async throws -> Event {
        try await request(requestConfiguration: API.eventDetails(event.id))
    }
}

extension EventDiscoveryRepository {
    enum API {
        case events(filter: Filter)
        case eventDetails(String)
    }
}

extension EventDiscoveryRepository.API: RequestConfiguration {
    var path: String {
        switch self {
        case .events:
            "/events"
        case let .eventDetails(id):
            "/events/\(id)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .events, .eventDetails:
            .GET
        }
    }

    var headers: [String: String]? {
        nil
    }

    var parameter: [String: Any]? {
        guard let apikey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String else {
            fatalError("API_KEY not found")
        }

        var params: [String: Any] = [
            "apikey": apikey,
        ]

        switch self {
        case let .events(filter):
            params.merge(filter.toDict()) { $1 }

        case .eventDetails: break
        }

        return params
    }

    var encoding: HTTPEncoding {
        .QUERY_STRING
    }
}
