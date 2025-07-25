//
//  MockURLSession.swift
//  Evently-EventsExplorer
//
//  Created by Nanda WK on 2025-07-25.
//

@testable import Evently_EventsExplorer
import Foundation

class MockURLSession: URLSessionProtocol {
    var data: Data?
    var response: URLResponse?
    var error: Error?
    var lastRequest: URLRequest?

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        lastRequest = request
        if let error {
            throw error
        }
        if let data, let response {
            return (data, response)
        }
        fatalError("MockURLSession: data or response not set.")
    }
}
