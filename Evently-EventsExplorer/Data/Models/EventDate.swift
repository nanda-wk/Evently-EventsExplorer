//
//  EventDate.swift
//  Evently-EventsExplorer
//
//  Created by Nanda WK on 2025-07-24.
//

struct EventDate: Codable {
    let start: StartDate?
}

struct StartDate: Codable {
    let localDate: String?
    let localTime: String?

    init(localDate: String? = "2025-08-11", localTime: String? = "19:00:00") {
        self.localDate = localDate
        self.localTime = localTime
    }
}
