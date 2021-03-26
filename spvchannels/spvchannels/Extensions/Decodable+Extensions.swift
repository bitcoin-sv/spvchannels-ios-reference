//
//  Decodable+Extensions.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

import Foundation

extension DateFormatter {
    static let iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}

extension Decodable {
    static func parse<T: Decodable>(from data: Data) -> T? {
        do {
            let decoder = JSONDecoder()
            decoder.dataDecodingStrategy = .base64
            decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
            return try decoder.decode(T.self, from: data)
        } catch {
            #if DEBUG
            print("============================================================")
            print("==== Error decoding JSON of type: \(type(of: self)) ====\n")
            print("\(error)\n")
            print(String(data: data, encoding: .utf8) ?? "")
            print("============================================================")
            #endif

            return nil
        }
    }

    static func parse<T: Decodable>(from string: String) -> T? {
        guard let data = string.data(using: .utf8) else { return nil }
        return parse(from: data)
    }

}
