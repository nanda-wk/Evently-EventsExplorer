//
//  Event.swift
//  Evently-EventsExplorer
//
//  Created by Nanda WK on 2025-07-24.
//

struct Event: Decodable {
    let id: String
    let name: String
    let info: String?
    let pleaseNote: String?
    let images: [EventImage]
    let date: EventDate
    let venue: Venue

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case info
        case pleaseNote
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
        info: String? = nil,
        pleaseNote: String? = nil,
        images: [EventImage] = [EventImage()],
        date: EventDate = EventDate(),
        venue: Venue = Venue()
    ) {
        self.id = id
        self.name = name
        self.info = info
        self.pleaseNote = pleaseNote
        self.images = images
        self.date = date
        self.venue = venue
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        info = try container.decodeIfPresent(String.self, forKey: .info)
        pleaseNote = try container.decodeIfPresent(String.self, forKey: .pleaseNote)
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
