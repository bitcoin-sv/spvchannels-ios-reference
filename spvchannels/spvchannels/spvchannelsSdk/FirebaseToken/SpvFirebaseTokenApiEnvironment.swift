//
//  SpvFirebaseTokenApiEnvironment.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

import Foundation

struct SpvFirebaseTokenApiEnvironment: EnvironmentProtocol {
    var baseUrl: String

    var headers: RequestHeaders? {
        [ "Content-Type": "application/json" ]
    }
    init(baseUrl: String) {
        self.baseUrl = baseUrl
    }
}
