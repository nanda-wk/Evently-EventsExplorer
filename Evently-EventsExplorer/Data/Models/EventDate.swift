//
//  EventDate.swift
//  Evently-EventsExplorer
//
//  Created by Nanda WK on 2025-07-24.
//

struct EventDate: Decodable {
    let localDate: String
    let localTime: String

    init(localDate: String = "2025-08-11", localTime: String = "19:00:00") {
        self.localDate = localDate
        self.localTime = localTime
    }

    enum CodingKeys: CodingKey {
        case localDate
        case localTime
    }
}
