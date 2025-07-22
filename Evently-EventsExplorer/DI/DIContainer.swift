//
//  DIContainer.swift
//  Evently-EventsExplorer
//
//  Created by Nanda WK on 2025-07-22.
//

import Foundation
import SwiftUI

struct DIContainer: EnvironmentKey {
    let services: Services

    static var defaultValue: Self { Self.default }

    private static let `default` = DIContainer(services: .stub)
}

extension DIContainer {
    struct Services {
        let eventDiscoveryService: EventDiscoveryServiceProtocol

        static var stub: Self {
            .init(eventDiscoveryService: StubEventDiscoveryService())
        }
    }
}

extension DIContainer {
    struct APIRepositories {
        let eventDiscoveryRepository: EventDiscoveryRepositoryProtocol
    }

    struct DBRepositories {}
}

#if DEBUG
    extension DIContainer {
        static var preview: Self {
            .init(services: .stub)
        }
    }
#endif
