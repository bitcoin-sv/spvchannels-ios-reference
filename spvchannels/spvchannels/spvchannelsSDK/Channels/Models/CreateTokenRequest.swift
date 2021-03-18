//
//  CreateTokenRequest.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

struct CreateTokenRequest: Codable {
    let canRead: Bool
    let canWrite: Bool
    let description: String
    enum CodingKeys: String, CodingKey {
        case description
        case canRead = "can_read"
        case canWrite = "can_write"
    }
}
