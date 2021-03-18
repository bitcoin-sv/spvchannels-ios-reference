//
//  ChannelPermissions.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

struct ChannelPermissions: Codable {
    let publicRead: Bool
    let publicWrite: Bool
    let locked: Bool
    enum CodingKeys: String, CodingKey {
        case publicRead = "public_read"
        case publicWrite = "public_write"
        case locked
    }
}
