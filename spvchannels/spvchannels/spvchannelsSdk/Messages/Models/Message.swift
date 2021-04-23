//
//  Message.swift
//  spvchannels
//
//  Copyright (c) 2021 Bitcoin Association.
//  Distributed under the Open BSV software license, see the accompanying file LICENSE
//

/// Structure to hold a single message received from a channel
public struct Message: Codable, Equatable {
    let sequence: Int
    let received: Date
    let contentType: String
    let payload: Data

    /// Helper method to decrypt message payload
    public func decrypted(with encryption: SpvEncryptionProtocol) -> Message? {
        guard let decryptedPayload = encryption.decrypt(input: payload) else { return nil }
        return Message(sequence: sequence, received: received, contentType: contentType,
                       payload: decryptedPayload)
    }
}
