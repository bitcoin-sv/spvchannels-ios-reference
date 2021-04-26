//
//  CreateChannelRequest.swift
//  spvchannels
//
//  Copyright (c) 2021 Bitcoin Association.
//  Distributed under the Open BSV software license, see the accompanying file LICENSE
//

/// Structure passed to Create Channel network API call describing new channel access and sequencing properties
public struct CreateChannelRequest: Codable {
    let publicRead: Bool
    let publicWrite: Bool
    let sequenced: Bool

    public init(publicRead: Bool, publicWrite: Bool, sequenced: Bool) {
        self.publicRead = publicRead
        self.publicWrite = publicWrite
        self.sequenced = sequenced
    }
}
