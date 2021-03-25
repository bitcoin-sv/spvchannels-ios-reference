//
//  SpvChannelApi.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

import Foundation

class SpvChannelApi {
    var requestDispatcher: RequestDispatcherProtocol

    init(baseUrl: String, accountId: String, username: String, password: String,
         networkSession: NetworkSessionProtocol = APINetworkSession()) {
        let baseUrlWithSuffix = baseUrl + "/api/v1/account/\(accountId)/channel"
        let env = SpvChannelsApiEnvironment(baseUrl: baseUrlWithSuffix,
                                            username: username,
                                            password: password)
        requestDispatcher = APIRequestDispatcher(environment: env,
                                                 networkSession: networkSession)
    }
}

extension SpvChannelApi: SpvChannelsApiProtocol {
    func getAllChannels(completion: @escaping ChannelsInfoResult) {
        let channelsRequest = ChannelsEndpoint.getAllChannels
        let operation = APIOperation(channelsRequest)

        operation.execute(in: requestDispatcher) { result in
            switch result {
            case .data(let data, _):
                if let data = data,
                   let result: ChannelsList = .parse(from: data) {
                    completion(.success(result))
                } else {
                    completion(.failure(APIError.parseError("JSON error")))
                }
            case .error(let error, _):
                operation.cancel()
                completion(.failure(error ?? APIError.unknown))
            }
        }
    }

    func getChannel(channelId: String, completion: @escaping ChannelInfoResult) {
        let channelsRequest = ChannelsEndpoint.getChannel(channelId: channelId)
        let operation = APIOperation(channelsRequest)

        operation.execute(in: requestDispatcher) { result in
            switch result {
            case .data(let data, _):
                if let data = data,
                   let result: ChannelInfo = .parse(from: data) {
                    completion(.success(result))
                } else {
                    completion(.failure(APIError.parseError("JSON error")))
                }
            case .error(let error, _):
                operation.cancel()
                completion(.failure(error ?? APIError.unknown))
            }
        }
    }

    func deleteChannel(channelId: String, completion: @escaping VoidResult) {
        let channelsRequest = ChannelsEndpoint.deleteChannel(channelId: channelId)
        let operation = APIOperation(channelsRequest)

        operation.execute(in: requestDispatcher) { result in
            switch result {
            case .data:
                completion(.success(()))
            case .error(let error, _):
                operation.cancel()
                completion(.failure(error ?? APIError.unknown))
            }
        }
    }

    func createChannel(createRequest: CreateChannelRequest, retention: Retention,
                       completion: @escaping ChannelInfoResult) {
        var parameters: [String: Any] = createRequest.asDictionary
        parameters["retention"] = retention.asDictionary
        let channelsRequest = ChannelsEndpoint.createChannel(parameters: parameters)
        let operation = APIOperation(channelsRequest)

        operation.execute(in: requestDispatcher) { result in
            switch result {
            case .data(let data, _):
                if let data = data,
                   let result: ChannelInfo = .parse(from: data) {
                    completion(.success(result))
                } else {
                    completion(.failure(APIError.parseError("JSON error")))
                }
            case .error(let error, _):
                operation.cancel()
                completion(.failure(error ?? APIError.unknown))
            }
        }
    }

    func getAllChannelTokens(channelId: String, completion: @escaping TokensInfoResult) {
        let channelsRequest = ChannelsEndpoint.getAllChannelTokens(channelId: channelId)
        let operation = APIOperation(channelsRequest)
        operation.execute(in: requestDispatcher) { result in
            switch result {
            case .data(let data, _):
                if let data = data,
                   let result: [ChannelToken] = .parse(from: data) {
                    completion(.success(result))
                } else {
                    completion(.failure(APIError.parseError("JSON error")))
                }
            case .error(let error, _):
                operation.cancel()
                completion(.failure(error ?? APIError.unknown))
            }
        }
    }

    func getChannelToken(channelId: String, tokenId: String, completion: @escaping TokenInfoResult) {
        let channelsRequest = ChannelsEndpoint.getChannelToken(channelId: channelId, tokenId: tokenId)
        let operation = APIOperation(channelsRequest)
        operation.execute(in: requestDispatcher) { result in
            switch result {
            case .data(let data, _):
                if let data = data,
                   let result: ChannelToken = .parse(from: data) {
                    completion(.success(result))
                } else {
                    completion(.failure(APIError.parseError("JSON error")))
                }
            case .error(let error, _):
                operation.cancel()
                completion(.failure(error ?? APIError.unknown))
            }
        }
    }

    func amendChannel(channelId: String, permissions: ChannelPermissions,
                      completion: @escaping ChannelPermissionsResult) {
        let parameters: [String: Any] = permissions.asDictionary
        let channelsRequest = ChannelsEndpoint.amendChannel(channelId: channelId, parameters: parameters)
        let operation = APIOperation(channelsRequest)

        operation.execute(in: requestDispatcher) { result in
            switch result {
            case .data(let data, _):
                if let data = data,
                   let result: ChannelPermissions = .parse(from: data) {
                    completion(.success(result))
                } else {
                    completion(.failure(APIError.parseError("JSON error")))
                }
            case .error(let error, _):
                operation.cancel()
                completion(.failure(error ?? APIError.unknown))
            }
        }
    }

    func createChannelToken(channelId: String, tokenRequest: CreateTokenRequest,
                            completion: @escaping TokenInfoResult) {
        let parameters: [String: Any] = tokenRequest.asDictionary
        let channelsRequest = ChannelsEndpoint.createChannelToken(channelId: channelId, parameters: parameters)
        let operation = APIOperation(channelsRequest)

        operation.execute(in: requestDispatcher) { result in
            switch result {
            case .data(let data, _):
                if let data = data,
                   let result: ChannelToken = .parse(from: data) {
                    completion(.success(result))
                } else {
                    completion(.failure(APIError.parseError("JSON error")))
                }
            case .error(let error, _):
                operation.cancel()
                completion(.failure(error ?? APIError.unknown))
            }
        }
    }

    func revokeChannelToken(channelId: String, tokenId: String, completion: @escaping VoidResult) {
        let channelsRequest = ChannelsEndpoint.revokeChannelToken(channelId: channelId, tokenId: tokenId)
        let operation = APIOperation(channelsRequest)
        operation.execute(in: requestDispatcher) { result in
            switch result {
            case .data:
                completion(.success(()))
            case .error(let error, _):
                operation.cancel()
                completion(.failure(error ?? APIError.unknown))
            }
        }
    }

}
