//
//  SpvFirebaseTokenApiEnvironment.swift
//  spvchannels
//
//  Copyright (c) 2021 Bitcoin Association.
//  Distributed under the Open BSV software license, see the accompanying file LICENSE
//

struct SpvFirebaseTokenApiEnvironment: EnvironmentProtocol {
    var baseUrl: String

    var headers: RequestHeaders? {
        [ "Content-Type": "application/json" ]
    }
    init(baseUrl: String) {
        self.baseUrl = baseUrl
    }
}
