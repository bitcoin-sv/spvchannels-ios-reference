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

    enum CodingKeys: String, CodingKey {
        case sequence, received, payload
        case contentType = "content_type"
    }

    func decrypted(with encryption: SpvEncryptionProtocol) -> Message {
        Message(sequence: sequence, received: received, contentType: contentType,
                payload: encryption.decrypt(input: payload))
    }
}
