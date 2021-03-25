//
//  CreateChannelRequest.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

struct CreateChannelRequest: Codable {
    let publicRead: Bool
    let publicWrite: Bool
    let sequenced: Bool
    enum CodingKeys: String, CodingKey {
        case publicRead = "public_read"
        case publicWrite = "public_write"
        case sequenced
    }

    var asDictionary: [String: Any] {
        [
            CodingKeys.publicRead.rawValue: publicRead,
            CodingKeys.publicWrite.rawValue: publicWrite,
            CodingKeys.sequenced.rawValue: sequenced
        ]
    }
}
