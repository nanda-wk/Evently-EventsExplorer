//
//  EventImage.swift
//  Evently-EventsExplorer
//
//  Created by Nanda WK on 2025-07-24.
//

import Foundation

struct EventImage: Decodable {
    let url: URL
    let width: Int
    let height: Int
    let ratio: Ratio?

    init(
        url: URL = URL(string: "https://example.com/image.jpg")!,
        width: Int = 640,
        height: Int = 360,
        ratio: Ratio = .the3_2
    ) {
        self.url = url
        self.width = width
        self.height = height
        self.ratio = ratio
    }

    enum CodingKeys: CodingKey {
        case url
        case width
        case height
        case ratio
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        url = try container.decode(URL.self, forKey: .url)
        width = try container.decode(Int.self, forKey: .width)
        height = try container.decode(Int.self, forKey: .height)
        ratio = try container.decodeIfPresent(Ratio.self, forKey: .ratio)
    }
}
