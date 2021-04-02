//
//  Decodable+Extensions.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

import Foundation

extension Decodable {
    static func parse<T: Decodable>(from data: Data) -> T? {
        do {
            let decoder = JSONDecoder()
            decoder.dataDecodingStrategy = .base64
            decoder.keyDecodingStrategy = .convertFromSnakeCase
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
