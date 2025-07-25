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

extension Loadable: Equatable where T: Equatable {
    static func == (lhs: Loadable<T>, rhs: Loadable<T>) -> Bool {
        switch (lhs, rhs) {
        case (.isLoading, .isLoading):
            true
        case let (.loaded(lhsV), .loaded(rhsV)): lhsV == rhsV
        case let (.failed(lhsE), .failed(rhsE)):
            lhsE.localizedDescription == rhsE.localizedDescription
        default: false
        }
    }
}
