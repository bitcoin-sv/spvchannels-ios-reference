//
//  Retention.swift
//  spvchannels
//
//  Copyright (c) 2021 Bitcoin Association.
//  Distributed under the Open BSV software license, see the accompanying file LICENSE
//

/// Struct containing channel message retention policy
struct Retention: Codable, Equatable {
    let minAgeDays: Int
    let maxAgeDays: Int
    let autoPrune: Bool

    init(minAgeDays: Int, maxAgeDays: Int, autoPrune: Bool) {
        self.minAgeDays = minAgeDays
        self.maxAgeDays = maxAgeDays
        self.autoPrune = autoPrune
    }

    init?(minAgeDays: String, maxAgeDays: String, autoPrune: Bool) {
        guard let minAge = Int(minAgeDays),
              let maxAge = Int(maxAgeDays)
        else { return nil }
        self.init(minAgeDays: minAge, maxAgeDays: maxAge, autoPrune: autoPrune)
    }
}
