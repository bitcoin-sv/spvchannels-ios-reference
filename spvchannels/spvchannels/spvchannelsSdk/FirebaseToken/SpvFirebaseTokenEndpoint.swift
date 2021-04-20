//
//  SpvFirebaseTokenApiEndpoint.swift
//  spvchannels
//
//  Copyright (c) 2021 Bitcoin Association.
//  Distributed under the Open BSV software license, see the accompanying file LICENSE
//

/// push notification token API call parameter definitions
enum FirebaseTokenEndpoint {

    case registerFcmToken(fcmToken: String, channelToken: String)
    case updateToken(oldToken: String, fcmToken: String)
    case deleteToken(oldToken: String, channelId: String?)
}

extension FirebaseTokenEndpoint: RequestProtocol {

    /// URL path of each API call
    var path: String {
        switch self {
        case .registerFcmToken:
            return "/"
        case .updateToken(let oldToken, _):
            return "/\(oldToken)"
        case .deleteToken(let oldToken, _):
            return "/\(oldToken)"
        }
    }

    /// HTTP method of each API call
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

    /// Additional HTTP headers of each API call
    var headers: RequestHeaders? {
        switch self {
        case .registerFcmToken(_, let channelToken):
            return [ "Authorization": "Bearer \(channelToken)"]
        case .updateToken, .deleteToken:
            return nil
        }
    }

    /// HTTP request URL parameters of each API call
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

    /// HTTP JSON body parameters of each API call
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

    /// HTTP raw data body of each specific API call
    var rawBody: Data? {
        nil
    }

}
