//
//  CreateTokenRequest.swift
//  spvchannels
//
//  Copyright (c) 2021 Bitcoin Association.
//  Distributed under the Open BSV software license, see the accompanying file LICENSE
//

/// Structure containing metadata and permissions for a new channel token
public struct CreateTokenRequest: Codable {
    let canRead: Bool
    let canWrite: Bool
    let description: String

    public init(canRead: Bool, canWrite: Bool, description: String) {
        self.canRead = canRead
        self.canWrite = canWrite
        self.description = description
    }
}
