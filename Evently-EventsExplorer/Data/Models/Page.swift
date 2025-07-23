//
//  Page.swift
//  Evently-EventsExplorer
//
//  Created by Nanda WK on 2025-07-24.
//

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
