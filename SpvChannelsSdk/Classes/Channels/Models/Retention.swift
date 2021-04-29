//
//  Retention.swift
//  spvchannels
//
//  Copyright (c) 2021 Bitcoin Association.
//  Distributed under the Open BSV software license, see the accompanying file LICENSE
//

/// Struct containing channel message retention policy
public struct Retention: Codable, Equatable {
    let minAgeDays: Int?
    let maxAgeDays: Int?
    let autoPrune: Bool

    public init(minAgeDays: Int?, maxAgeDays: Int?, autoPrune: Bool) {
        self.minAgeDays = minAgeDays
        self.maxAgeDays = maxAgeDays
        self.autoPrune = autoPrune
    }

    public init?(minAgeDays: String, maxAgeDays: String, autoPrune: Bool) {
        let minAge = Int(minAgeDays)
        let maxAge = Int(maxAgeDays)
        self.init(minAgeDays: minAge, maxAgeDays: maxAge, autoPrune: autoPrune)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeNullableOptional(minAgeDays, forKey: .minAgeDays)
        try container.encodeNullableOptional(maxAgeDays, forKey: .maxAgeDays)
        try container.encode(autoPrune, forKey: .autoPrune)
    }
}
