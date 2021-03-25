//
//  SpvChannelEndpoint.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

import Foundation

enum ChannelsEndpoint {
    enum Actions: CaseIterable {
        case getAllChannels, getChannel, createChannel, amendChannel, deleteChannel, getAllChannelTokens
        case getChannelToken, createChannelToken, revokeChannelToken

        var actionTitle: String {
            switch self {
            case .getAllChannels:
                return "List All Channels"
            case .getChannel:
                return "Get Channel"
            case .createChannel:
                return "Create Channel"
            case .deleteChannel:
                return "Delete Channel"
            case .amendChannel:
                return "Amend Channel"
            case .getAllChannelTokens:
                return "Get All Channel Tokens"
            case .getChannelToken:
                return "Get Channel Token"
            case .createChannelToken:
                return "Generate Channel Token"
            case .revokeChannelToken:
                return "Revoke Channel Token"
            }
        }
    }

    case getAllChannels
    case getChannel(channelId: String)
    case createChannel(parameters: [String: Any])
    case deleteChannel(channelId: String)
    case getAllChannelTokens(channelId: String)
    case getChannelToken(channelId: String, tokenId: String)
    case revokeChannelToken(channelId: String, tokenId: String)
    case createChannelToken(channelId: String, parameters: [String: Any])
    case amendChannel(channelId: String, parameters: [String: Any])
}

extension ChannelsEndpoint: RequestProtocol {
    var path: String {
        switch self {
        case .getAllChannels:
            return "/list"
        case .getChannel(let channelId):
            return "/\(channelId)"
        case .deleteChannel(let channelId):
            return "/\(channelId)"
        case .getAllChannelTokens(let channelId):
            return "/\(channelId)/api-token"
        case .getChannelToken(let channelId, let tokenId):
            return "/\(channelId)/api-token/\(tokenId)"
        case .revokeChannelToken(let channelId, let tokenId):
            return "/\(channelId)/api-token/\(tokenId)"
        case .createChannel:
            return "/"
        case .createChannelToken(let channelId, _):
            return "/\(channelId)/api-token"
        case .amendChannel(let channelId, _):
            return "/\(channelId)"
        }
    }

    var method: RequestMethod {
        switch self {
        case .getAllChannels:
            return .get
        case .getChannel:
            return .get
        case .deleteChannel:
            return .delete
        case .getAllChannelTokens:
            return .get
        case .getChannelToken:
            return .get
        case .revokeChannelToken:
            return .delete
        case .createChannel:
            return .post
        case .createChannelToken:
            return .post
        case .amendChannel:
            return .post
        }
    }

    var headers: RequestHeaders? {
        nil
    }

    var parameters: RequestParameters? {
        switch self {
        case .getAllChannels:
            return nil
        case .getChannel:
            return nil
        case .deleteChannel:
            return nil
        case .getAllChannelTokens:
            return nil
        case .getChannelToken:
            return nil
        case .revokeChannelToken:
            return nil
        case .createChannel(let parameters):
            return parameters
        case .amendChannel(_, let parameters):
            return parameters
        case .createChannelToken(_, let parameters):
            return parameters
        }
    }

}
