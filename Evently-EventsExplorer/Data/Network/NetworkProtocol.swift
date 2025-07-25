//
//  NetworkProtocol.swift
//  Evently-EventsExplorer
//
//  Created by Nanda WK on 2025-07-22.
//

import Foundation

protocol URLSessionProtocol {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}

protocol NetworkProtocol {
    var session: URLSessionProtocol { get }
}

extension NetworkProtocol {
    func request<Value: Decodable>(
        requestConfiguration: RequestConfiguration
    ) async throws -> Value {
        let decoder: JSONDecoder = {
            let decoder = JSONDecoder()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            return decoder
        }()

        let httpCodes = HTTPCodes.success
        let request = try requestConfiguration.urlRequest()
        let (data, response) = try await session.data(for: request)

        guard let code = (response as? HTTPURLResponse)?.statusCode else {
            throw NetworkError.unexpectedResponse
        }

        guard httpCodes.contains(code) else {
            throw NetworkError.httpCode(code)
        }

        do {
            return try decoder.decode(Value.self, from: data)
        } catch {
            throw NetworkError.invalidDecoding(error)
        }
    }
}
