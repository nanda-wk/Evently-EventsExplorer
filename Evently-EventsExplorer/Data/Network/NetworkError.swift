//
//  NetworkError.swift
//  Evently-EventsExplorer
//
//  Created by Nanda WK on 2025-07-22.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case httpCode(HTTPCode)
    case unexpectedResponse
    case imageDeserialization
    case invalidEncoding
    case invalidDecoding(Error)
}

extension NetworkError: Equatable {
    static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL), (.unexpectedResponse, .unexpectedResponse), (.imageDeserialization, .imageDeserialization), (.invalidEncoding, .invalidEncoding): true
        case let (.httpCode(lhsCode), .httpCode(rhsCode)): lhsCode == rhsCode
        case let (.invalidDecoding(lhsError), .invalidDecoding(rhsError)): lhsError as NSError == rhsError as NSError
        default: false
        }
    }
}
