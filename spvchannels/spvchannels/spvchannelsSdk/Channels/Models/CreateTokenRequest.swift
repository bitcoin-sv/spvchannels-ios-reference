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

    var asDictionary: [String: Any] {
        [
            CodingKeys.canRead.rawValue: canRead,
            CodingKeys.canWrite.rawValue: canWrite,
            CodingKeys.description.rawValue: description
        ]
    }

}
