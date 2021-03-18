//
//  SpvCredentials.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

struct SpvCredentials {
    let accountId: String
    let userName: String
    let password: String

    func basicAuth() -> String? {
        guard let data = "\(userName):\(password)".data(using: .utf8) else { return nil }
        let credential = data.base64EncodedString(options: [])
        return "Basic \(credential)"
    }
}
