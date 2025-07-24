//
//  Filter.swift
//  Evently-EventsExplorer
//
//  Created by Nanda WK on 2025-07-22.
//

import Foundation

struct Filter: Codable {
    var keyword: String?
    var page: Int?
}

extension Filter {
    func toDict() -> [String: Any] {
        do {
            let data = try JSONEncoder().encode(self)
            let dic = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
            return dic ?? [:]
        } catch {
            return [:]
        }
    }
}
