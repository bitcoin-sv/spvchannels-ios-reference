//
//  RequestProtocol.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

import Foundation

typealias RequestHeaders = [String: String]
typealias RequestParameters = [String: Any]

protocol EnvironmentProtocol {
    var headers: RequestHeaders? { get }
    var baseUrl: String { get }
}

enum RequestMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
    case head = "HEAD"
}

protocol RequestProtocol {
    var path: String { get }
    var method: RequestMethod { get }
    var headers: RequestHeaders? { get }
    var parameters: RequestParameters? { get }
    var rawBody: Data? { get }
}

extension RequestProtocol {
    public func urlRequest(with environment: EnvironmentProtocol) -> URLRequest? {
        guard let url = url(with: environment.baseUrl) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        request.httpBody = jsonBody
        return request
    }

    private func url(with baseUrl: String) -> URL? {
        guard var urlComponents = URLComponents(string: baseUrl) else { return nil }
        urlComponents.path += path
        urlComponents.queryItems = queryItems
        return urlComponents.url
    }

    private var queryItems: [URLQueryItem]? {
        guard method == .get, let parameters = parameters else { return nil }
        return parameters.compactMap { key, value in
            return URLQueryItem(name: key, value: String(describing: value))
        }
    }

    private var jsonBody: Data? {
        if let rawBody = rawBody {
            return rawBody
        }
        guard [.post, .put, .patch].contains(method), let parameters = parameters else { return nil }
        return try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
    }
}
