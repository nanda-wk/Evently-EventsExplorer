//
//  Loadable.swift
//  Evently-EventsExplorer
//
//  Created by Nanda WK on 2025-07-22.
//

import Foundation

enum Loadable<T> {
    case isLoading
    case loaded(T)
    case failed(Error)
}
