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
}
