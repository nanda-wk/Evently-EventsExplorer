//
//  AppEnvironment.swift
//  Evently-EventsExplorer
//
//  Created by Nanda WK on 2025-07-22.
//

import Foundation

struct AppEnvironment {
    let container: DIContainer
}

extension AppEnvironment {
    static func bootstrap() -> AppEnvironment {
        let session = configureURLSession()
        let apiRepositories = configureRepositories(session: session)
        let services = configureServices(apiRepositories: apiRepositories)
        let diContainer = DIContainer(services: services)

        return .init(container: diContainer)
    }

    private static func configureURLSession() -> URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 120
        configuration.waitsForConnectivity = false
        configuration.httpMaximumConnectionsPerHost = 5
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        configuration.urlCache = .shared
        return URLSession(configuration: configuration)
    }

    private static func configureRepositories(session: URLSession) -> DIContainer.APIRepositories {
        let eventRepository = EventDiscoveryRepository(session: session)

        return .init(eventDiscoveryRepository: eventRepository)
    }

    private static func configureServices(
        apiRepositories: DIContainer.APIRepositories
    ) -> DIContainer.Services {
        let eventService = EventDiscoveryService(apiRepository: apiRepositories.eventDiscoveryRepository)
        return .init(eventDiscoveryService: eventService)
    }
}
