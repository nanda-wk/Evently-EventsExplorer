//
//  Promoter.swift
//  Evently-EventsExplorer
//
//  Created by Nanda WK on 2025-07-24.
//

struct Promoter: Codable {
    let id: String?
    let name: String?
    let description: String?

    init(
        id: String? = nil,
        name: String? = nil,
        description: String? = nil
    ) {
        self.id = id
        self.name = name
        self.description = description
    }
}
