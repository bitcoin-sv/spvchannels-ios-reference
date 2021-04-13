//
//  RequestProtocol.swift
//  spvchannels
//
//  Copyright (c) 2021 Bitcoin Association.
//  Distributed under the Open BSV software license, see the accompanying file LICENSE
//

/// String dictionaries for request URL headers and body parameters
typealias RequestHeaders = [String: String]
typealias RequestParameters = [String: Any]

/// Abstraction protocol for the Environment object
protocol EnvironmentProtocol {
    var headers: RequestHeaders? { get }
    var baseUrl: String { get }
}

/// HTTP request method map
enum RequestMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
    case head = "HEAD"
}

/// Required properties of each request
protocol RequestProtocol {
    var path: String { get }
    var method: RequestMethod { get }
    var headers: RequestHeaders? { get }
    var urlParameters: RequestParameters? { get }
    var bodyParameters: RequestParameters? { get }
    var rawBody: Data? { get }
}

/// Implementation of request building from required properties
extension RequestProtocol {
    public func urlRequest(with environment: EnvironmentProtocol) -> URLRequest? {
        guard let url = url(with: environment.baseUrl) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        if [.post, .put, .patch].contains(method) {
            if let rawBody = rawBody {
                request.httpBody = rawBody
            } else {
                request.httpBody = jsonBody
            }
        }
        return request
    }

    private func url(with baseUrl: String) -> URL? {
        guard var urlComponents = URLComponents(string: baseUrl) else { return nil }
        urlComponents.path += path
        urlComponents.queryItems = queryItems
        return urlComponents.url
    }

    private var queryItems: [URLQueryItem]? {
        guard let parameters = urlParameters else { return nil }
        return parameters.compactMap { key, value in
            return URLQueryItem(name: key, value: String(describing: value))
        }
    }

    private var jsonBody: Data? {
        guard [.post, .put, .patch].contains(method), let parameters = bodyParameters else { return nil }
        return try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
    }
}
