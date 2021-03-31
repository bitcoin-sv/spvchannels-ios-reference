//
//  SpvFirebaseTokenApi.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

import Foundation

class SpvFirebaseTokenApi {
    var requestDispatcher: RequestDispatcherProtocol

    init(baseUrl: String, networkSession: NetworkSessionProtocol = APINetworkSession()) {
        let baseUrlWithSuffix = baseUrl + "/api/v1/firebasetoken"
        let env = SpvFirebaseTokenApiEnvironment(baseUrl: baseUrlWithSuffix)
        requestDispatcher = APIRequestDispatcher(environment: env,
                                                 networkSession: networkSession)
    }
}

extension SpvFirebaseTokenApi: SpvFirebaseTokenApiProtocol {

    func updateFirebaseToken(token: String, completion: @escaping StringResult) {
        guard !token.isEmpty else { return }
        // REMOVE WHEN REAL ENDPOINT AVAILABLE
        #if ENDPOINT_AVAILABLE
        let parameters: [String: Any] = ["firebase_token": token]
        let tokenRequest = FirebaseTokenEndpoint.updateFirebaseToken(parameters: parameters)
        let operation = APIOperation(tokenRequest)
        operation.execute(in: requestDispatcher) { result in
            switch result {
            case .data:
                completion(.success("OK"))
            case .error(let error, _):
                operation.cancel()
                completion(.failure(error ?? APIError.unknown))
            }
        }
        #else
        completion(.success("OK"))
        return
        #endif
    }
}
