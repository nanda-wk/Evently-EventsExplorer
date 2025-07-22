//
//  PageableListResult.swift
//  Evently-EventsExplorer
//
//  Created by Nanda WK on 2025-07-22.
//

import Foundation

struct PageableListResult<Resule: Decodable>: Decodable {
    let page: Page
}
