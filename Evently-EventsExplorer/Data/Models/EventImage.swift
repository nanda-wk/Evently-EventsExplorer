//
//  EventImage.swift
//  Evently-EventsExplorer
//
//  Created by Nanda WK on 2025-07-24.
//

import Foundation

struct EventImage: Codable, Equatable {
    let url: URL?
    let width: Int?
    let height: Int?
    let ratio: Ratio?
}
