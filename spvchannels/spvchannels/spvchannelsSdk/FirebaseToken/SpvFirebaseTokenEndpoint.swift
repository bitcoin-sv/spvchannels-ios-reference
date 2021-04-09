//
//  SpvFirebaseTokenApiEndpoint.swift
//  spvchannels
//
//  Copyright (c) 2021 Bitcoin Association.
//  Distributed under the Open BSV software license, see the accompanying file LICENSE
//

enum FirebaseTokenEndpoint {
    case updateFirebaseToken(parameters: [String: Any])
}

extension FirebaseTokenEndpoint: RequestProtocol {

    var path: String {
        "/"
    }

    var method: RequestMethod {
        .post
    }

    var headers: RequestHeaders? {
        nil
    }

    var rawBody: Data? {
        nil
    }

    var urlParameters: RequestParameters? {
        nil
    }

    var bodyParameters: RequestParameters? {
        switch self {
        case .updateFirebaseToken(let parameters):
            return parameters
        }
    }

}
