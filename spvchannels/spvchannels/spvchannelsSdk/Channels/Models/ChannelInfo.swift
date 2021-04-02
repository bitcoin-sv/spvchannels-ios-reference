//
//  ChannelInfo.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

struct ChannelInfo: Codable, Equatable {
    let id: String
    let href: String
    let publicRead: Bool
    let publicWrite: Bool
    let sequenced: Bool
    let locked: Bool
    let head: Int
    let retention: Retention?
    let accessTokens: [ChannelToken]
}

struct ChannelsList: Codable, Equatable {
    let channels: [ChannelInfo]
}
