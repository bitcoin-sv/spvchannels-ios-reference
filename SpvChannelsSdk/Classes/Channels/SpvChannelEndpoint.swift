//
//  SpvChannelEndpoint.swift
//  spvchannels
//
//  Copyright (c) 2021 Bitcoin Association.
//  Distributed under the Open BSV software license, see the accompanying file LICENSE
//

/// Channels API endpoint definition
enum ChannelsEndpoint {

    /// Channels API call parameter definitions
    case getAllChannels
    case getChannel(channelId: String)
    case createChannel(parameters: [String: Any])
    case deleteChannel(channelId: String)
    case getAllChannelTokens(channelId: String, token: String)
    case getChannelToken(channelId: String, tokenId: String)
    case revokeChannelToken(channelId: String, tokenId: String)
    case createChannelToken(channelId: String, parameters: [String: Any])
    case amendChannel(channelId: String, parameters: [String: Any])
}

extension ChannelsEndpoint: RequestProtocol {

    /// URL path of each API call
    var path: String {
        switch self {
        case .getAllChannels:
            return "/list"
        case .getChannel(let channelId):
            return "/\(channelId)"
        case .deleteChannel(let channelId):
            return "/\(channelId)"
        case .getAllChannelTokens(let channelId, _):
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

    /// HTTP method of each API call
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

    /// Additional HTTP headers of each API call
    var headers: RequestHeaders? {
        nil
    }

    /// HTTP request URL parameters of each API call
    var urlParameters: RequestParameters? {
        switch self {
        case .getAllChannelTokens(_, let token):
            return ["token": token]
        default:
            return nil
        }
    }

    /// HTTP JSON body parameters of each API call
    var bodyParameters: RequestParameters? {
        switch self {
        case .getAllChannels, .getChannel, .deleteChannel, .getAllChannelTokens, .getChannelToken, .revokeChannelToken:
            return nil
        case .createChannel(let parameters):
            return parameters
        case .amendChannel(_, let parameters):
            return parameters
        case .createChannelToken(_, let parameters):
            return parameters
        }
    }

    /// HTTP raw data body of each specific API call
    var rawBody: Data? {
        return nil
    }

}
