//
//  SearchViewModel.swift
//  Evently-EventsExplorer
//
//  Created by Nanda WK on 2025-07-24.
//

import Foundation

class SearchViewModel {
    private(set) var events: [Event] = []
    private(set) var page = 0
    private(set) var canLoadMore = true
    private(set) var isFetching = false

    var keyword = ""
    private(set) var isEventListEmpty = false

    var onUpdate: (() -> Void)?

    let container: DIContainer

    init(container: DIContainer) {
        self.container = container
    }

    func reset() {
        events.removeAll()
        page = 0
        canLoadMore = true
        isFetching = false
        isEventListEmpty = false
    }

    func loadEvents(reset: Bool = false) async {
        if reset {
            self.reset()
        }

        guard !isFetching, canLoadMore else { return }
        isFetching = true
        onUpdate?()

        do {
            print("Fetching page \(page) for keyword: \(keyword)")
            let filter = Filter(keyword: keyword, page: page)
            let pagedEvents = try await container.services.eventDiscoveryService.load(with: filter)
            let newEvents = pagedEvents.embedded?.events ?? []

            events.append(contentsOf: newEvents)
            isEventListEmpty = events.isEmpty

            page += 1
            canLoadMore = page < pagedEvents.page.totalPages
        } catch {
            print("Fetch error: \(error)")
            isEventListEmpty = true
        }
        isFetching = false
        onUpdate?()
    }

    func numberOfRows() -> Int {
        events.count
    }

    func event(at index: Int) -> Event {
        events[index]
    }
}
