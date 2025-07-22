//
//  HomeViewModel.swift
//  Evently-EventsExplorer
//
//  Created by Nanda WK on 2025-07-22.
//

import Foundation

extension Home {
    @MainActor
    class ViewModel: ObservableObject {
        @Published var events: Loadable<Events> = .isLoading

        let container: DIContainer

        init(container: DIContainer) {
            self.container = container
        }

        func loadEvents() async {
            events = .isLoading
            do {
                let events = try await container.services.eventDiscoveryService.load()
                self.events = .loaded(events)
            } catch {
                events = .failed(error)
            }
        }
    }
}
