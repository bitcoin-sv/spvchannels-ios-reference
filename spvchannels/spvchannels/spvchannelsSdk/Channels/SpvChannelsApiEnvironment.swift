//
//  SpvChannelsApiEnvironment.swift
//  spvchannels
//
//  Copyright (c) 2021 Bitcoin Association.
//  Distributed under the Open BSV software license, see the accompanying file LICENSE
//

/**
 API environment that provides appropriate authentication for the network session and sets base URL

 # Notes: #
 
 This takes care of HTTP Basic authentication for the Channels API requirement
*/
struct SpvChannelsApiEnvironment: EnvironmentProtocol {
    var baseUrl: String
    private var username: String
    private var password: String

    var basicAuth: String {
        guard let data = "\(username):\(password)".data(using: .utf8) else { return "" }
        let credential = data.base64EncodedString(options: [])
        return "Basic \(credential)"
    }

    var headers: RequestHeaders? {
        [ "Content-Type": "application/json",
          "Authorization": basicAuth]
    }
    /**
     - parameter baseUrl: Base URL of the SPV channels server to connect to
     - parameter username: SPV channels server username to use
     - parameter password: SPV channels server password to use
     */
    init(baseUrl: String, username: String, password: String) {
        self.baseUrl = baseUrl
        self.username = username
        self.password = password
    }
}
