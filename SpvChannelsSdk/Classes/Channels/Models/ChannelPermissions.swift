//
//  ChannelPermissions.swift
//  spvchannels
//
//  Copyright (c) 2021 Bitcoin Association.
//  Distributed under the Open BSV software license, see the accompanying file LICENSE
//

/// Structure containing channel metadata and permissions
public struct ChannelPermissions: Codable {
    let publicRead: Bool
    let publicWrite: Bool
    let locked: Bool

    public init(publicRead: Bool, publicWrite: Bool, locked: Bool) {
        self.publicRead = publicRead
        self.publicWrite = publicWrite
        self.locked = locked
    }
}
