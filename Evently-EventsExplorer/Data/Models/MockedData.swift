//
//  MockedData.swift
//  Evently-EventsExplorer
//
//  Created by Nanda WK on 2025-07-22.
//

import Foundation

#if DEBUG
    extension Events {
        static let mockData: Events = .init(embedded: .mockData, page: .mockData)
    }

    extension EmbeddedEvents {
        static let mockData: EmbeddedEvents = .init(events: [.mockData])
    }

    extension Page {
        static let mockData: Page = .init(
            size: 10,
            totalElements: 50,
            totalPages: 5,
            number: 1
        )
    }

    extension Event {
        static var mockData: Event = .init(
            id: "G5vVZbowl3fyp",
            name: "New York Yankees vs. Houston Astros",
            info: "Please adhere to published limits. Persons who exceed the ticket limit may have any or all of their orders and tickets cancelled without notice by Ticketmaster in its discretion. This includes orders associated with the same name, e-mail, billing address, credit card number or other information. If you purchase tickets, you may receive customer service messages via email from the New York Yankees, including optional surveys regarding your baseball experience. Ticket holder assumes all risk of injury from balls and bats entering the stands. Please note that protective netting of varying heights is used in the Stadium from Section 011 to behind home plate to Section 029. For more information, please visit yankees.com/netting. The number of innings in a regulation game shall be determined by MLB and may be shortened in accordance with MLB rules. Licensor makes no representation, warranty and/or guarantee that nine (9) innings will be played in any regulation game.",
            promoter: .mockData,
            images: [.mockData, .mockData],
            dates: .mockData,
            embedded: .mockData
        )
    }

    extension Promoter {
        static let mockData: Promoter = .init(id: "685", name: "MLB REGULAR SEASON", description: "MLB REGULAR SEASON / NTL / USA")
    }

    extension EventImage {
        static let mockData: EventImage = .init(
            url: .init(string: "https://s1.ticketm.net/dam/a/7e0/479ac7e7-15fb-44ba-8708-fc1bf2d037e0_RETINA_PORTRAIT_3_2.jpg")!,
            width: 640,
            height: 427,
            ratio: .the3_2
        )
    }

    extension EventDate {
        static let mockData: EventDate = .init(start: .mockData)
    }

    extension StartDate {
        static let mockData: StartDate = .init()
    }

    extension EmbeddedVenues {
        static let mockData: EmbeddedVenues = .init(venues: [.mockData])
    }

    extension Venue {
        static let mockData: Venue = .init(
            id: "KovZpZA6t77A",
            name: "Yankee Stadium",
            city: .mockData,
            state: .mockData,
            country: .mockData,
            address: .mockData,
            location: .mockData
        )
    }

    extension City {
        static let mockData: City = .init(name: "Bronx")
    }

    extension VenueState {
        static let mockData: VenueState = .init(name: "New York", stateCode: "NY")
    }

    extension Country {
        static let mockData: Country = .init(name: "United States Of America", countryCode: "US")
    }

    extension Address {
        static let mockData: Address = .init(line1: "1 East 161st Street", line2: "2 East 161st Street", line3: "3 East 161st Street")
    }

    extension VenueLocation {
        static let mockData: VenueLocation = .init(longitude: "-73.92762640", latitude: "40.82852370")
    }

#endif
