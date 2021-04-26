//
//  NoOpEncryption.swift
//  spvchannels
//
//  Copyright (c) 2021 Bitcoin Association.
//  Distributed under the Open BSV software license, see the accompanying file LICENSE
//

/// Payload encryption service that does no encryption
public struct SpvNoOpEncryption: SpvEncryptionProtocol {

    public func encrypt(input: Data) -> Data? {
        input
    }

    public func decrypt(input: Data) -> Data? {
        input
    }

    public init() {}

}
