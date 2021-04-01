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
