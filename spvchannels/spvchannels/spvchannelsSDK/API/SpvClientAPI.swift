//
//  SpvClientAPI.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

import Foundation

class SpvClientAPI {

    var baseUrl: String
    var credentials: SpvCredentials

    init(baseUrl: String, credentials: SpvCredentials) {
        self.baseUrl = baseUrl
        self.credentials = credentials
    }

    enum Endpoint: CaseIterable {
        case getAllChannels
        case getChannel
        case createChannel
        case amendChannel
        case deleteChannel
        case getAllChannelTokens
        case getChannelToken
        case createChannelToken
        case revokeChannelToken

        var urlString: String {
            switch self {
            case .getAllChannels: return "/api/v1/account/{accountId}/channel/list"
            case .createChannel: return "/api/v1/account/{accountId}/channel"
            case .amendChannel: return "/api/v1/account/{accountId}/channel/{channelId}"
            case .getChannel: return "/api/v1/account/{accountId}/channel/{channelId}"
            case .deleteChannel: return "/api/v1/account/{accountId}/channel/{channelId}"
            case .getAllChannelTokens: return "/api/v1/account/{accountId}/channel/{channelId}/api-token"
            case .getChannelToken: return "/api/v1/account/{accountId}/channel/{channelId}/api-token/{tokenId}"
            case .createChannelToken: return "/api/v1/account/{accountId}/channel/{channelId}/api-token"
            case .revokeChannelToken: return "/api/v1/account/{accountId}/channel/{channelId}/api-token/{tokenId}"
            }
        }

        var urlKeys: [String] {
            switch self {
            case .getAllChannels: return ["accountId"]
            case .createChannel: return ["accountId"]
            case .amendChannel: return ["accountId", "channelId"]
            case .getChannel: return ["accountId", "channelId"]
            case .deleteChannel: return ["accountId", "channelId"]
            case .getAllChannelTokens: return ["accountId", "channelId"]
            case .getChannelToken: return ["accountId", "channelId", "tokenId"]
            case .createChannelToken: return ["accountId", "channelId"]
            case .revokeChannelToken: return ["accountId", "channelId", "tokenId"]
            }
        }

        var actionTitle: String {
            switch self {
            case .getChannel:
                return "Get Channel"
            case .getChannelToken:
                return "Get Channel API Token"
            case .getAllChannelTokens:
                return "Get All Channel API Tokens"
            case .getAllChannels:
                return "List All Channels"
            case .createChannel:
                return "Create Channel"
            case .deleteChannel:
                return "Delete Channel"
            case .amendChannel:
                return "Amend Channel"
            case .createChannelToken:
                return "Generate Channel API Token"
            case .revokeChannelToken:
                return "Revoke Channel API Token"
            }
        }

        func buildUrl(params: [String: String] = [:], queries: [String: String] = [:]) -> URL? {
            var urlStr = self.urlString
            let requiredKeys = self.urlKeys.sorted()
            guard requiredKeys == params.keys.sorted() else { return nil }
            params.forEach { urlStr = urlStr.replacingOccurrences(of: "{\($0)}", with: $1) }
            guard let url = URL(string: urlStr) else { return nil }
            return queries.isEmpty ? url : url.withQueries(queries)
        }
    }
}

func toJson<Value>(_ item: Value) -> String where Value: Encodable {
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    if let jsonData = try? encoder.encode(item),
       let jsonStr = String(data: jsonData, encoding: .utf8) {
        return jsonStr
    } else {
        return "JSON parsing Error"
    }
}

extension SpvClientAPI: SpvChannelsApiProtocol {

    func getAllChannels(accountId: String,
                        completion: @escaping ChannelsInfoResult) {
        let worker = GetAllChannelsWorker(baseUrl: baseUrl, credentials: credentials)
        worker.execute(accountId: accountId) { result in
            completion(result)
        }
    }

    func getChannel(accountId: String, channelId: String,
                    completion: @escaping ChannelInfoResult) {
        let worker = GetChannelWorker(baseUrl: baseUrl, credentials: credentials)
        worker.execute(accountId: accountId, channelId: channelId) { result in
            completion(result)
        }
    }

    func createChannel(accountId: String,
                       completion: @escaping ChannelInfoResult) {
        let worker = CreateChannelWorker(baseUrl: baseUrl, credentials: credentials)
        worker.execute(accountId: accountId) { result in
            completion(result)
        }
    }

    func deleteChannel(accountId: String, channelId: String,
                       completion: @escaping VoidResult) {
        let worker = DeleteChannelWorker(baseUrl: baseUrl, credentials: credentials)
        worker.execute(accountId: accountId, channelId: channelId) { result in
            completion(result)
        }
    }

    func getAllChannelTokens(accountId: String, channelId: String,
                             completion: @escaping TokensInfoResult) {
        let worker = GetAllChannelTokensWorker(baseUrl: baseUrl, credentials: credentials)
        worker.execute(accountId: accountId, channelId: channelId) { result in
            completion(result)
        }
    }

    func amendChannel(accountId: String, channelId: String, permissions: ChannelPermissions,
                      completion: @escaping VoidResult) {
        let worker = AmendChannelWorker(baseUrl: baseUrl, credentials: credentials)
        worker.execute(accountId: accountId, channelId: channelId, permissions: permissions) { result in
            completion(result)
        }
    }

    func createChannelToken(accountId: String, channelId: String, tokenRequest: CreateTokenRequest,
                            completion: @escaping TokenInfoResult) {
        let worker = CreateChannelTokenWorker(baseUrl: baseUrl, credentials: credentials)
        worker.execute(accountId: accountId, channelId: channelId, tokenRequest: tokenRequest) { result in
            completion(result)
        }
    }

    func getChannelToken(accountId: String, channelId: String, tokenId: String,
                         completion: @escaping TokenInfoResult) {
        let worker = GetChannelTokenWorker(baseUrl: baseUrl, credentials: credentials)
        worker.execute(accountId: accountId, channelId: channelId, tokenId: tokenId) { result in
            completion(result)
        }
    }

    func revokeChannelToken(accountId: String, channelId: String, tokenId: String,
                            completion: @escaping VoidResult) {
        let worker = RevokeChannelTokenWorker(baseUrl: baseUrl, credentials: credentials)
        worker.execute(accountId: accountId, channelId: channelId, tokenId: tokenId) { result in
            completion(result)
        }
    }

}
