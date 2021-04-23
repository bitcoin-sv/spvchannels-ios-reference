//
//  SpvFirebaseTokenApiProtocol.swift
//  spvchannels
//
//  Copyright (c) 2021 Bitcoin Association.
//  Distributed under the Open BSV software license, see the accompanying file LICENSE
//

public protocol SpvFirebaseTokenApiProtocol {

    var fcmToken: String? { get }

    // MARK: FirebaseToken API
    typealias StringResult = (Result<String, Error>) -> Void

    func registerFcmToken(fcmToken: String, channelToken: String,
                          completion: @escaping StringResult)
    func updateToken(oldToken: String, fcmToken: String,
                     completion: @escaping StringResult)
    func deleteToken(oldToken: String, channelId: String?,
                     completion: @escaping StringResult)
    func receivedNewToken(newToken: String)
    func updateTokenIfStoredDifferent()
}

extension SpvFirebaseTokenApiProtocol {
    func deleteToken(oldToken: String,
                     completion: @escaping StringResult) {
        deleteToken(oldToken: oldToken, channelId: nil, completion: completion)
    }
}
