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
        @Published var events: Loadable<[Event]> = .isLoading
        @Published var shouldLoadMore: Bool = true

        private(set) var isLoadingMore: Bool = false
        private(set) var allEvents: [Event] = []
        private(set) var page = 0

        let container: DIContainer

        init(container: DIContainer) {
            self.container = container
        }

        func loadEvents(reset: Bool = false) async {
            guard !isLoadingMore, shouldLoadMore else { return }

            if reset {
                page = 0
                allEvents.removeAll()
            }

            isLoadingMore = true

            do {
                let filter = Filter(page: page)
                let pagedEvents = try await container.services.eventDiscoveryService.load(with: filter)
                let newEvents = pagedEvents.embedded?.events ?? []

                allEvents.append(contentsOf: newEvents)

                page += 1
                shouldLoadMore = page < pagedEvents.page.totalPages
                events = .loaded(allEvents)
            } catch {
                events = .failed(error)
            }

            isLoadingMore = false
        }
    }
}
