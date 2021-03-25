//
//  Retention.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

struct Retention: Codable, Equatable {
    let minAgeDays: Int
    let maxAgeDays: Int
    let autoPrune: Bool
    enum CodingKeys: String, CodingKey {
        case minAgeDays = "min_age_days"
        case maxAgeDays = "max_age_days"
        case autoPrune = "auto_prune"
    }

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

    var asDictionary: [String: Any] {
        [
            CodingKeys.minAgeDays.rawValue: minAgeDays,
            CodingKeys.maxAgeDays.rawValue: maxAgeDays,
            CodingKeys.autoPrune.rawValue: autoPrune
        ]
    }
}
