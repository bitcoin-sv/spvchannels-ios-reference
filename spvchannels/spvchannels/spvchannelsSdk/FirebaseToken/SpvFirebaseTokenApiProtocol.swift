//
//  SpvFirebaseTokenApiProtocol.swift
//  spvchannels
//
//  Copyright (c) 2021 Bitcoin Association.
//  Distributed under the Open BSV software license, see the accompanying file LICENSE
//

protocol SpvFirebaseTokenApiProtocol {

    // MARK: FirebaseToken API
    typealias StringResult = (Result<String, Error>) -> Void

    func registerFcmToken(fcmToken: String, channelToken: String,
                          completion: @escaping StringResult)
    func updateToken(oldToken: String, fcmToken: String,
                     completion: @escaping StringResult)
    func deleteToken(oldToken: String, channelId: String?,
                     completion: @escaping StringResult)
}

extension SpvFirebaseTokenApiProtocol {
    func deleteToken(oldToken: String,
                     completion: @escaping StringResult) {
        deleteToken(oldToken: oldToken, channelId: nil, completion: completion)
    }
}
