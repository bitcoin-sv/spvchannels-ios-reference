//
//  SpvFirebaseTokenApiEndpoint.swift
//  spvchannels
//
//  Copyright (c) 2021 Bitcoin Association.
//  Distributed under the Open BSV software license, see the accompanying file LICENSE
//

enum FirebaseTokenEndpoint {

    case registerFcmToken(fcmToken: String, channelToken: String)
    case updateToken(oldToken: String, fcmToken: String)
    case deleteToken(oldToken: String, channelId: String?)
}

extension FirebaseTokenEndpoint: RequestProtocol {

    var path: String {
        switch self {
        case .registerFcmToken:
            return "/pushnotifications"
        case .updateToken(let oldToken, _):
            return "/pushnotifications/\(oldToken)"
        case .deleteToken(let oldToken, _):
            return "/pushnotifications/\(oldToken)"
        }
    }

    var method: RequestMethod {
        switch self {
        case .registerFcmToken:
            return .post
        case .updateToken:
            return .put
        case .deleteToken:
            return .delete
        }
    }

    var headers: RequestHeaders? {
        switch self {
        case .registerFcmToken(_, let channelToken):
            return [ "Authorization": "Bearer \(channelToken)"]
        case .updateToken, .deleteToken:
            return nil
        }
    }

    var rawBody: Data? {
        nil
    }

    var urlParameters: RequestParameters? {
        switch self {
        case .registerFcmToken, .updateToken:
            return nil
        case .deleteToken(_, let channelId):
            if let channelId = channelId {
                return ["channelId": channelId ]
            } else {
                return nil
            }
        }
    }

    var bodyParameters: RequestParameters? {
        switch self {
        case .registerFcmToken(let fcmToken, _):
            return ["token": fcmToken]
        case .updateToken(_, let fcmToken):
        return ["token": fcmToken]
        case .deleteToken:
            return nil
        }
    }

}
