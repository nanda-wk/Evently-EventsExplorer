//
//  RequestConfiguration.swift
//  Evently-EventsExplorer
//
//  Created by Nanda WK on 2025-07-22.
//

import Combine
import Foundation

protocol RequestConfiguration {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var parameter: [String: Any]? { get }
    var encoding: HTTPEncoding { get }
}

extension RequestConfiguration {
    var baseURL: String {
        guard let url = Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as? String else {
            fatalError("API_BASE_URL not found")
        }
        return url + "/discovery/v2"
    }
}

extension RequestConfiguration {
    func urlRequest() throws -> URLRequest {
        guard let URL = URL(string: baseURL + path) else {
            throw NetworkError.invalidURL
        }
        var request = URLRequest(url: URL)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        if let parameter {
            switch encoding {
            case .JSON:
                do {
                    request.httpBody = try JSONSerialization.data(withJSONObject: parameter, options: [])
                } catch {
                    throw NetworkError.invalidEncoding
                }
            case .QUERY_STRING:
                request.url = request.url?.appending(queryItems: parameter.map { URLQueryItem(name: $0.key, value: String(describing: $0.value)) })
            }
        }
        return request
    }
}

enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
}

enum HTTPEncoding {
    case JSON
    case QUERY_STRING
}
