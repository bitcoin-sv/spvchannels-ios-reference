//
//  TokenInfo.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

struct ChannelToken: Codable, Equatable {
    let id: String
    let token: String
    let description: String
    let canRead: Bool
    let canWrite: Bool
    enum CodingKeys: String, CodingKey {
        case id, token, description
        case canRead = "can_read"
        case canWrite = "can_write"
    }
}
