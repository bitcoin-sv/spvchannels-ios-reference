//
//  SpvChannelsApiEnvironment.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

import Foundation

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
    init(baseUrl: String, username: String, password: String) {
        self.baseUrl = baseUrl
        self.username = username
        self.password = password
    }
}
