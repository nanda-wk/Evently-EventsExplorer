//
//  MockedData.swift
//  Evently-EventsExplorer
//
//  Created by Nanda WK on 2025-07-22.
//

import Foundation

#if DEBUG
    extension Events {
        static let mockData: Events = .init(
            events: [
                .mockData,
                Event(
                    name: "Rock Concert",
                    images: [
                        .mockData,
                    ],
                    date: .mockData,
                    venue: .mockData
                ),
            ],
            page: .mockData
        )
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
            name: "New York Yankees vs. Houston Astros",
            images: [.mockData],
            date: .mockData,
            venue: .mockData
        )
    }

    extension EventImage {
        static let mockData: EventImage = .init(
            url: .init(string: "https://s1.ticketm.net/dam/a/7e0/479ac7e7-15fb-44ba-8708-fc1bf2d037e0_ARTIST_PAGE_3_2.jpg")!,
            width: 305,
            height: 203,
            ratio: .the3_2
        )
    }

    extension EventDate {
        static let mockData: EventDate = .init()
    }

    extension Venue {
        static let mockData: Venue = .init(
            name: "Sample Venue",
            city: "Sample City",
            state: "Sample State",
            country: "Sample Country",
            address: "123 Sample St",
            latitude: "12.3456",
            longitude: "78.9012"
        )
    }

#endif
