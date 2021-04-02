//
//  Codable+Extensions.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

import Foundation

extension Encodable {

    private func customDataEncoder(data: Data, encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        if let str = String(data: data, encoding: .utf8) {
            try container.encode(str)
        } else {
            try container.encode(data.base64EncodedString())
        }
    }

    func encoded() -> Data? {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.dataEncodingStrategy = .custom(customDataEncoder)
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = .prettyPrinted
        return try? encoder.encode(self)
    }

    func jsonString() -> String {
        guard let data = encoded(),
           let jsonStr = String(data: data, encoding: .utf8)
        else { return "" }
        return jsonStr
    }

    var asDictionary: [String: Any] {
        guard let data = encoded(),
              let dictionary = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            return [:]
        }
        return dictionary
    }

}
