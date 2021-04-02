//
//  CreateChannelRequest.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

struct CreateChannelRequest: Codable {
    let publicRead: Bool
    let publicWrite: Bool
    let sequenced: Bool
}
