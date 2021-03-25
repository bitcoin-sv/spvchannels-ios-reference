//
//  Codable+Extensions.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

import Foundation

extension Encodable {
    func encoded() -> Data? {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.outputFormatting = .prettyPrinted
        return try? encoder.encode(self)
    }

    func jsonString() -> String {
        guard let data = encoded(),
           let jsonStr = String(data: data, encoding: .utf8)
        else { return "" }
        return jsonStr
    }
}
