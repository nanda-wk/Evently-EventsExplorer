//
//  Events.swift
//  Evently-EventsExplorer
//
//  Created by Nanda WK on 2025-07-22.
//

import Foundation

struct Events: Decodable {
    let events: [Event]
    let page: Page

    enum CodingKeys: String, CodingKey {
        case embedded = "_embedded"
        case page
        case links = "_links"
    }

    enum EmbeddedKeys: String, CodingKey {
        case events
    }

    init(events: [Event] = [Event()], page: Page = Page()) {
        self.events = events
        self.page = page
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // Decode events
        if let embeddedContainer = try? container.nestedContainer(keyedBy: EmbeddedKeys.self, forKey: .embedded) {
            events = try embeddedContainer.decode([Event].self, forKey: .events)
        } else {
            events = []
        }

        page = try container.decode(Page.self, forKey: .page)
    }
}
