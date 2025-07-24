//
//  SearchViewModel.swift
//  Evently-EventsExplorer
//
//  Created by Nanda WK on 2025-07-24.
//

import Foundation

class SearchViewModel {
    private(set) var events: [Event] = []
    private var page = 0
    private var canLoadMore = true
    private var isFetching = false

    var keyword = ""

    var onUpdate: (() -> Void)?

    let container: DIContainer

    init(container: DIContainer) {
        self.container = container
    }

    func reset() {
        events.removeAll()
        page = 0
        canLoadMore = true
    }

    func loadEvents(reset: Bool = false) async {
        guard !isFetching, canLoadMore else { return }
        isFetching = true

        if reset {
            self.reset()
        }

        do {
            print("Fetching page \(page) for keyword: \(keyword)")
            let filter = Filter(keyword: keyword, page: page)
            let pagedEvents = try await container.services.eventDiscoveryService.load(with: filter)
            let newEvents = pagedEvents.events

            events.append(contentsOf: newEvents)

            page += 1
            canLoadMore = page < pagedEvents.page.totalPages
            onUpdate?()
        } catch {
            print("Fetch error: \(error)")
        }
        isFetching = false
    }

    func numberOfRows() -> Int {
        events.count
    }

    func event(at index: Int) -> Event {
        events[index]
    }
}
