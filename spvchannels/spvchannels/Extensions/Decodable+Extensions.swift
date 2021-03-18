//
//  Decodable+Extensions.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

import Foundation

extension Decodable {
    static func parse<T: Decodable>(from data: Data, type: T.Type) -> T? {
        do {
            return try JSONDecoder().decode(type.self, from: data)
        } catch {
            #if DEBUG
            print("============================================================")
            print("==== Error decoding JSON of type: \(type.self) ====\n")
            print("\(error)\n")
            print(String(data: data, encoding: .utf8) ?? "")
            print("============================================================")
            #endif

            return nil
        }
    }

    static func parseArray<T: Decodable>(from data: Data, type: T.Type) -> [T] {
        do {
            return try JSONDecoder().decode([T].self, from: data)
        } catch {
            #if DEBUG
            print("============================================================")
            print("==== Error decoding JSON Array of type: \(type.self) ====\n")
            print("\(error.localizedDescription)\n")
            print(String(data: data, encoding: .utf8) ?? "")
            print("============================================================")
            #endif

            return []
        }
    }

    static func parse<T: Decodable>(from string: String, type: T.Type) -> T? {
        guard let data = string.data(using: .utf8) else { return nil }
        return parse(from: data, type: type)
    }

    static func parseArray<T: Decodable>(from string: String, type: T.Type) -> [T] {
        guard let data = string.data(using: .utf8) else { return [] }
        return parseArray(from: data, type: type)
    }
}
