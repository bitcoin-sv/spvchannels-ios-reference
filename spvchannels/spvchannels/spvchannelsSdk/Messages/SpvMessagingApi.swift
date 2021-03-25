//
//  SpvMessagingApi.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

import Foundation

class SpvMessagingApi {
    var baseUrl: String
    var channelId: String
    var tokenId: String

    init(baseUrl: String, channelId: String, tokenId: String) {
        self.baseUrl = baseUrl
        self.channelId = channelId
        self.tokenId = tokenId
    }
}
