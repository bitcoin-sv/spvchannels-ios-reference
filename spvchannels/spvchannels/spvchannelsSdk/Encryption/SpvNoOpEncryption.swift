//
//  NoOpEncryption.swift
//  spvchannels
//
//  Copyright (c) 2021 Bitcoin Association.
//  Distributed under the Open BSV software license, see the accompanying file LICENSE
//

/// Payload encryption service that does no encryption
struct SpvNoOpEncryption: SpvEncryptionProtocol {

    func encrypt(input: Data) -> Data? {
        input
    }

    func decrypt(input: Data) -> Data? {
        input
    }

}
