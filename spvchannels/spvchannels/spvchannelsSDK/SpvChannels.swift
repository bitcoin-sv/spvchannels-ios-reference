//
//  spvchannelsSDK.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

import Foundation

class SpvChannels {

    var networkService: SpvChannelsApiProtocol

    init(baseUrl: String, credentials: SpvCredentials, networkService: SpvChannelsApiProtocol) {
        self.networkService = networkService
        self.networkService.credentials = credentials
        self.networkService.baseUrl = baseUrl
    }

    convenience init(baseUrl: String, credentials: SpvCredentials) {
        let networkService = SpvClientApi(baseUrl: baseUrl, credentials: credentials)
        self.init(baseUrl: baseUrl, credentials: credentials, networkService: networkService)
    }

}
