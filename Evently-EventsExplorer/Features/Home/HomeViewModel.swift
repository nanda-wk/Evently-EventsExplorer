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
        @Published var shouldLoadMore: Bool = false

        private var isLoadingMore: Bool = false
        private var allEvents: [Event] = []
        private var page = 0
        private var totalPages = 0

        let container: DIContainer

        init(container: DIContainer) {
            self.container = container
        }

        func loadEvents(reset: Bool = false) async {
            guard !isLoadingMore else { return }

            if reset {
                page = 0
                totalPages = 0
                allEvents.removeAll()
            }

            isLoadingMore = true

            do {
                let filter = Filter(page: page)
                let pagedEvents = try await container.services.eventDiscoveryService.load(with: filter)
                let newEvents = pagedEvents.events

                allEvents.append(contentsOf: newEvents)

                events = .loaded(allEvents)
                page += 1
                totalPages = pagedEvents.page.totalPages
                shouldLoadMore = page < totalPages
            } catch {
                events = .failed(error)
            }

            isLoadingMore = false
        }
    }
}
