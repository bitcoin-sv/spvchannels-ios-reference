//
//  SpvFirebaseTokenApiEndpoint.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

import Foundation

enum FirebaseTokenEndpoint {
    case updateFirebaseToken(parameters: [String: Any])
}

extension FirebaseTokenEndpoint: RequestProtocol {

    var path: String {
        switch self {
        case .updateFirebaseToken:
            return "/"
        }
    }

    var method: RequestMethod {
        switch self {
        case .updateFirebaseToken:
            return .post
        }
    }

    var headers: RequestHeaders? {
        nil
    }

    var rawBody: Data? {
        return nil
    }

    var urlParameters: RequestParameters? {
        return nil
    }

    var bodyParameters: RequestParameters? {
        switch self {
        case .updateFirebaseToken(let parameters):
            return parameters
        }
    }

}
