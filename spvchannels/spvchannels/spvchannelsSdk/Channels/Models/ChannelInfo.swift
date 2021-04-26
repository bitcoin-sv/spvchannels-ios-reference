//
//  ChannelInfo.swift
//  spvchannels
//
//  Copyright (c) 2021 Bitcoin Association.
//  Distributed under the Open BSV software license, see the accompanying file LICENSE
//

/// Structure to hold single channel info
public struct ChannelInfo: Codable, Equatable {
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

/// Structure to hold an array of channel info
public struct ChannelsList: Codable, Equatable {
    let channels: [ChannelInfo]
}
