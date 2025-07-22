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
//        links = try container.decode(Links.self, forKey: .links)
    }
}

struct Page: Decodable {
    let size: Int
    let totalElements: Int
    let totalPages: Int
    let number: Int

    init(size: Int = 0, totalElements: Int = 0, totalPages: Int = 0, number: Int = 0) {
        self.size = size
        self.totalElements = totalElements
        self.totalPages = totalPages
        self.number = number
    }
}

struct Links: Decodable {
    let next: Link?

    struct Link: Decodable {
        let href: String
        let templated: Bool?
    }

    enum CodingKeys: String, CodingKey {
        case next
    }
}

struct Event: Decodable {
    let id: String
    let name: String
    let images: [EventImage]
    let date: EventDate
    let venue: Venue

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case images
        case dates
        case embedded = "_embedded"
    }

    enum DatesKeys: String, CodingKey {
        case start
    }

    enum EmbeddedKeys: String, CodingKey {
        case venues
    }

    init(
        id: String = "1",
        name: String = "Sample Event",
        images: [EventImage] = [EventImage()],
        date: EventDate = EventDate(),
        venue: Venue = Venue()
    ) {
        self.id = id
        self.name = name
        self.images = images
        self.date = date
        self.venue = venue
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        images = try container.decode([EventImage].self, forKey: .images)

        // Decode date
        let datesContainer = try container.nestedContainer(keyedBy: DatesKeys.self, forKey: .dates)
        date = try datesContainer.decode(EventDate.self, forKey: .start)

        // Decode venue
        let embeddedContainer = try container.nestedContainer(keyedBy: EmbeddedKeys.self, forKey: .embedded)
        var venuesArray = try embeddedContainer.decode([Venue].self, forKey: .venues)
        venue = venuesArray.removeFirst()
    }
}

struct EventImage: Decodable {
    let url: String
    let width: Int
    let height: Int
    let ratio: Ratio

    init(
        url: String = "https://example.com/image.jpg",
        width: Int = 640,
        height: Int = 360,
        ratio: Ratio = .the3_2
    ) {
        self.url = url
        self.width = width
        self.height = height
        self.ratio = ratio
    }
}

enum Ratio: String, Decodable {
    case the16_9 = "16_9"
    case the3_2 = "3_2"
    case the4_3 = "4_3"
}

struct EventDate: Decodable {
    let localDate: String

    init(localDate: String = "2025-08-01") {
        self.localDate = localDate
    }
}

struct Venue: Decodable {
    let name: String
    let city: String
    let state: String
    let country: String
    let address: String
    let latitude: String
    let longitude: String

    enum CodingKeys: String, CodingKey {
        case name
        case city
        case state
        case country
        case address
        case location
    }

    enum CityKeys: String, CodingKey {
        case name
    }

    enum StateKeys: String, CodingKey {
        case name
    }

    enum CountryKeys: String, CodingKey {
        case name
    }

    enum AddressKeys: String, CodingKey {
        case line1
    }

    enum LocationKeys: String, CodingKey {
        case latitude
        case longitude
    }

    init(
        name: String = "Sample Venue",
        city: String = "Sample City",
        state: String = "Sample State",
        country: String = "Sample Country",
        address: String = "123 Sample St",
        latitude: String = "0.0",
        longitude: String = "0.0"
    ) {
        self.name = name
        self.city = city
        self.state = state
        self.country = country
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        name = try container.decode(String.self, forKey: .name)

        let cityContainer = try container.nestedContainer(keyedBy: CityKeys.self, forKey: .city)
        city = try cityContainer.decode(String.self, forKey: .name)

        let stateContainer = try container.nestedContainer(keyedBy: StateKeys.self, forKey: .state)
        state = try stateContainer.decode(String.self, forKey: .name)

        let countryContainer = try container.nestedContainer(keyedBy: CountryKeys.self, forKey: .country)
        country = try countryContainer.decode(String.self, forKey: .name)

        let addressContainer = try container.nestedContainer(keyedBy: AddressKeys.self, forKey: .address)
        address = try addressContainer.decode(String.self, forKey: .line1)

        let locationContainer = try container.nestedContainer(keyedBy: LocationKeys.self, forKey: .location)
        latitude = try locationContainer.decode(String.self, forKey: .latitude)
        longitude = try locationContainer.decode(String.self, forKey: .longitude)
    }
}
