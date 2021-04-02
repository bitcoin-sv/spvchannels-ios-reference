//
//  Message.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

import Foundation

struct Message: Codable, Equatable {
    let sequence: Int
    let received: Date
    let contentType: String
    let payload: Data

    func decrypted(with encryption: SpvEncryptionProtocol) -> Message? {
        guard let decryptedPayload = encryption.decrypt(input: payload) else { return nil }
        return Message(sequence: sequence, received: received, contentType: contentType,
                       payload: decryptedPayload)
    }
}
