//
//  Events.swift
//  Evently-EventsExplorer
//
//  Created by Nanda WK on 2025-07-22.
//

import Foundation

struct Events: Codable {
    let embedded: EmbeddedEvents?
    let page: Page

    enum CodingKeys: String, CodingKey {
        case embedded = "_embedded"
        case page
    }

    init(embedded: EmbeddedEvents? = .init(), page: Page = .init()) {
        self.embedded = embedded
        self.page = page
    }
}

struct EmbeddedEvents: Codable {
    let events: [Event]

    enum CodingKeys: String, CodingKey {
        case events
    }

    init(events: [Event] = [Event()]) {
        self.events = events
    }
}
