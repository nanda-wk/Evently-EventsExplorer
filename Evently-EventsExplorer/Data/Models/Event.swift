//
//  Event.swift
//  Evently-EventsExplorer
//
//  Created by Nanda WK on 2025-07-24.
//

struct Event: Codable {
    let id: String
    let name: String?
    let info: String?
    let promoter: Promoter?
    let images: [EventImage]
    let dates: EventDate?
    let embedded: EmbeddedVenues?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case info
        case promoter
        case images
        case dates
        case embedded = "_embedded"
    }

    init(
        id: String = "",
        name: String? = nil,
        info: String? = nil,
        promoter: Promoter? = nil,
        images: [EventImage] = [],
        dates: EventDate? = nil,
        embedded: EmbeddedVenues? = .init()
    ) {
        self.id = id
        self.name = name
        self.info = info
        self.promoter = promoter
        self.images = images
        self.dates = dates
        self.embedded = embedded
    }
}

struct EmbeddedVenues: Codable {
    let venues: [Venue]

    init(venues: [Venue] = [Venue()]) {
        self.venues = venues
    }
}
