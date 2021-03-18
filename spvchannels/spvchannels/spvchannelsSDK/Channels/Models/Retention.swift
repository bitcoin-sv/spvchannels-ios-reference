//
//  Retention.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

struct Retention: Codable {
    let minAgeDays: Int
    let maxAgeDays: Int
    let autoPrune: Bool
    enum CodingKeys: String, CodingKey {
        case minAgeDays = "min_age_days"
        case maxAgeDays = "max_age_days"
        case autoPrune = "auto_prune"
    }
}
