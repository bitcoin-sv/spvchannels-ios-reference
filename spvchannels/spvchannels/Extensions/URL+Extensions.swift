//
//  URL+Extensions.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

import Foundation

extension URL {

    func withQueries(_ queries: [String: String]) -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: false)
        components?.queryItems = queries.compactMap { URLQueryItem(name: $0.0, value: $0.1) }
        return components?.url
    }
}
