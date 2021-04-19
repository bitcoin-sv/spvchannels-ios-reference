//
//  SpvFirebaseTokenApi.swift
//  spvchannels
//
//  Copyright (c) 2021 Bitcoin Association.
//  Distributed under the Open BSV software license, see the accompanying file LICENSE
//

/// Class for executing Firebase token refresh API network calls
class SpvFirebaseTokenApi {
    var requestDispatcher: RequestDispatcherProtocol

    init(baseUrl: String, networkSession: NetworkSessionProtocol = APINetworkSession()) {
        let baseUrlWithSuffix = baseUrl + "/api/v1/pushnotifications"
        let env = SpvFirebaseTokenApiEnvironment(baseUrl: baseUrlWithSuffix)
        requestDispatcher = APIRequestDispatcher(environment: env,
                                                 networkSession: networkSession)
    }
}

extension SpvFirebaseTokenApi: SpvFirebaseTokenApiProtocol {

    /// registers passed Firebase token to receive push notifications, authenticate with the channel token
    func registerFcmToken(fcmToken: String, channelToken: String, completion: @escaping StringResult) {
        guard !fcmToken.isEmpty, !channelToken.isEmpty else {
            completion(.failure(APIError.badRequest("fcmToken or channelToken cannot be empty")))
            return
        }
        let tokensRequest = FirebaseTokenEndpoint.registerFcmToken(fcmToken: fcmToken, channelToken: channelToken)
        let operation = APIOperation(tokensRequest)
        operation.execute(in: requestDispatcher) { result in
            switch result {
            case .data:
                completion(.success("OK"))
            case .error(let error, _):
                operation.cancel()
                completion(.failure(error ?? APIError.unknown))
            }
        }
    }

    /// sends an FCM token update with old and new value, will be applied in all registered channels
    func updateToken(oldToken: String, fcmToken: String, completion: @escaping StringResult) {
        guard !oldToken.isEmpty, !fcmToken.isEmpty else {
            completion(.failure(APIError.badRequest("oldToken or fcmToken cannot be empty")))
            return
        }
        let tokensRequest = FirebaseTokenEndpoint.updateToken(oldToken: oldToken, fcmToken: fcmToken)
        let operation = APIOperation(tokensRequest)
        operation.execute(in: requestDispatcher) { result in
            switch result {
            case .data:
                completion(.success("OK"))
            case .error(let error, _):
                operation.cancel()
                completion(.failure(error ?? APIError.unknown))
            }
        }
    }

    /// send a delete Firebase Messaging token request for the passed channel id, stop receiving its push notifications
    /// if channel ID is nil, removes that token from all registered channel
    func deleteToken(oldToken: String, channelId: String?, completion: @escaping StringResult) {
        guard !oldToken.isEmpty else {
            completion(.failure(APIError.badRequest("oldToken cannot be empty")))
            return
        }
        let tokensRequest = FirebaseTokenEndpoint.deleteToken(oldToken: oldToken, channelId: channelId)
        let operation = APIOperation(tokensRequest)
        operation.execute(in: requestDispatcher) { result in
            switch result {
            case .data:
                completion(.success("OK"))
            case .error(let error, _):
                operation.cancel()
                completion(.failure(error ?? APIError.unknown))
            }
        }
    }

}
