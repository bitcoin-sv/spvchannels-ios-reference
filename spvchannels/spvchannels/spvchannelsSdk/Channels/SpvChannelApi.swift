//
//  SpvChannelApi.swift
//  spvchannels
//
//  Copyright (c) 2021 Bitcoin Association.
//  Distributed under the Open BSV software license, see the accompanying file LICENSE
//

/// Class for executing Channel API network calls
class SpvChannelApi {
    let requestDispatcher: RequestDispatcherProtocol

    /**
     Class for executing Channel API network calls
     
     - parameter baseUrl: retrieved from the SpvChannelSdk class
     - parameter accountId: account ID on the server
     - parameter username: username on the server to use with channel authentication
     - parameter password: password on the server to use with channel authentication
     - parameter networkSession: class corresponding to NetworkSessionProtocol to use for calls
     - warning: The credentials provided are not checked at Channel API initialization time

     # Notes: #
     Providing your own class to networkSession allows you perform unit testing with mock network responses
     
     # Example #
     ```
     let channelApi = spvChannelsSdk?
            .channelWithCredentials(accountId: accountId,
                                    username: username,
                                    password: password)
     ```
     */
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

    /**
     Retrieves a list of all channels
     
     - parameter completion: Code block to execute with result when response is received
     - returns: array of channel info  in ChannelList type
     
     # Example #
     ```
     spvChannelApi.getAllChannels { result in
        if case let .success(data) = result {
            print(data.channels.count)
        }
     }
     ```
     */
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

    /**
     Retrieves a single channel info
     
     - parameter channelId: identifier of channel to retrieve info for
     - parameter completion: Code block to execute with result when response is received
     - returns: channel info in ChannelInfo type
     
     # Example #
     ```
     spvChannelApi.getChannel(channelId: channelId) { result in
        if case let .success(data) = result {
            print(data.href)
        }
     }
     ```
     */
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

    /**
     Deletes a single channel
     
     - parameter channelId: Identifier of channel to delete
     - parameter completion: Code block to execute with result when response is received
     - warning: There is no undo for this operation!
     - returns: channel info in ChannelInfo type
     
     # Example #
     ```
     spvChannelApi.getChannel(channelId: channelId) { result in
        if case let .success(data) = result {
            print(data.href)
        }
     }
     ```
     */
    func deleteChannel(channelId: String, completion: @escaping StringResult) {
        let channelsRequest = ChannelsEndpoint.deleteChannel(channelId: channelId)
        let operation = APIOperation(channelsRequest)

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

    /**
     Creates a new channel, owned by the account holder
     
     - parameter createRequest: Structure holding info whether the channel is readable, writable and sequenced
     - parameter retention: Structure holding message retention policy on the server (min, max age and auto-prune)
     - parameter completion: Code block to execute with result when response is received
     - returns: channel info in ChannelInfo type
     
     # Example #
     ```
     spvChannelApi.createChannel { result in
        if case let .success(data) = result {
            print(data.href)
        }
     }
     ```
     */
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

    /**
     Retrieves a list of channel tokens. Can be made to optionally filter on a specific token value (not token ID!)
     
     - parameter channelId: Identifier of channel to query
     - parameter token: Optionally channel token value to filter on (empty to retrieve all)
     - parameter completion: Code block to execute with result when response is received
     - returns: array of token info in [ChannelToken] type
     
     # Example #
     ```
     spvChannelApi.getAllChannelTokens(channelId: channelId,
                                       token: token) { result in
        if case let .success(data) = result {
            print(data.count)
        }
     }
     ```
     */
    func getAllChannelTokens(channelId: String, token: String, completion: @escaping TokensInfoResult) {
        let channelsRequest = ChannelsEndpoint.getAllChannelTokens(channelId: channelId, token: token)
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

    /**
     Retrieves a specific channel token info, identified by token ID (not token value!).
     
     - parameter channelId: Identifier of channel to query
     - parameter tokenId: Token ID (not value!)
     - parameter completion: Code block to execute with result when response is received
     - returns: single token info in ChannelToken type
     
     # Example #
     ```
     spvChannelApi.getChannelToken(channelId: channelId,
                                   tokenId: tokenId) { result in
        if case let .success(data) = result {
            print(data.description)
        }
     }
     ```
     */
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

    /**
     Updates Channel metadata and permissions (read/write and locking a channel)
     
     - parameter channelId: Identifier of channel to query
     - parameter createRequest: Structure holding new permissions for the channel
     - parameter completion: Code block to execute with result when response is received
     - returns: channel permissions info in ChannelPermissions type
     
     Locked channel definition:
      - writing to a locked channel is not allowed
      - reading from a locked channel is allowed
      - restrictions are implemented on server side
     
     # Example #
     ```
     let permissions = ChannelPermissions(publicRead: true,
                                          publicWrite: true,
                                          locked: false)
     
     spvChannelApi.amendChannel(channelId: channelId,
                                permissions: permissions) { result in
        if case let .success(data) = result {
            print(data.publicWrite)
        }
     }
     ```
     */
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

    /**
     Generate a new API token for the given channel
     
     - parameter channelId: Identifier of channel to query
     - parameter tokenRequest: Structure holding permissions for the new token
     - parameter completion: Code block to execute with result when response is received
     - returns: single token info in ChannelToken type
     
     # Example #
     ```
     let newToken = CreateTokenRequest(canRead: true,
                                       canWrite: false,
                                       description: "readonly token")

     spvChannelApi.createChannelToken(channelId: channelId,
                                      tokenRequest: newToken) { result in
        if case let .success(data) = result {
            print(data.description)
        }
     }
     ```
     */
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

    /**
     Used to revoke (delete) a specific token for the given channel, identified by ID (not value!).
     
     - parameter channelId: Identifier of channel to query
     - parameter tokenId: Token ID (not value!)
     - parameter completion: Code block to execute with result when response is received
     - returns: success or failure status
     
     # Example #
     ```
     spvChannelApi.revokeChannelToken(channelId: channelId,
                                      tokenId: tokenId) { result in
        if case .success = result {
            print("token revoked")
        }
     }
     ```
     */
    func revokeChannelToken(channelId: String, tokenId: String, completion: @escaping StringResult) {
        let channelsRequest = ChannelsEndpoint.revokeChannelToken(channelId: channelId, tokenId: tokenId)
        let operation = APIOperation(channelsRequest)
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
