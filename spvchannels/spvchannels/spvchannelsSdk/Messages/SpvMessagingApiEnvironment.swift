//
//  SpvMessagingApiEnvironment.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

import Foundation

struct SpvMessagingApiEnvironment: EnvironmentProtocol {
    var baseUrl: String
    private var token: String

    var headers: RequestHeaders? {
        [ "Authorization": "Bearer \(token)" ]
    }
    init(baseUrl: String, token: String) {
        self.baseUrl = baseUrl
        self.token = token
    }
}
