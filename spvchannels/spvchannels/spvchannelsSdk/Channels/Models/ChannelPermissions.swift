//
//  ChannelPermissions.swift
//  spvchannels
//
//  Copyright (c) 2021 Bitcoin Association.
//  Distributed under the Open BSV software license, see the accompanying file LICENSE
//

/// Structure containing channel metadata and permissions
struct ChannelPermissions: Codable {
    let publicRead: Bool
    let publicWrite: Bool
    let locked: Bool
}
