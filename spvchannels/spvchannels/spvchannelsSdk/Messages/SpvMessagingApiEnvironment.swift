//
//  SpvMessagingApiEnvironment.swift
//  spvchannels
//
//  Copyright (c) 2021 Bitcoin Association.
//  Distributed under the Open BSV software license, see the accompanying file LICENSE
//

/**
 API environment that provides appropriate authentication for the network session and sets base URL

 - parameter baseUrl: Base URL of the SPV channels server to connect to
 - parameter token: Channel access token to use
 
 # Notes: #
 This takes care of HTTP Bearer token authentication for the Messaging API requirement
*/
struct SpvMessagingApiEnvironment: EnvironmentProtocol {
    var baseUrl: String
    private var token: String

    var headers: RequestHeaders? {
        [ "Authorization": "Bearer \(token)" ]
    }

    /**
     - parameter baseUrl: Base URL of the SPV channels server to connect to
     - parameter token: Channel access token to use
     */
    init(baseUrl: String, token: String) {
        self.baseUrl = baseUrl
        self.token = token
    }
}
