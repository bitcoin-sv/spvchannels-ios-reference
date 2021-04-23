//
//  ChannelToken.swift
//  spvchannels
//
//  Copyright (c) 2021 Bitcoin Association.
//  Distributed under the Open BSV software license, see the accompanying file LICENSE
//

/// Structure describing a single channel access token properties
public struct ChannelToken: Codable, Equatable {
    let id: String
    let token: String
    let description: String
    let canRead: Bool
    let canWrite: Bool
}
