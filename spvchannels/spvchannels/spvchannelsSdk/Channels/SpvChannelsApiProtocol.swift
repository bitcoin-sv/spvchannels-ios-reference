//
//  SpvChannelsApiProtocol.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

import Foundation

protocol SpvChannelsApiProtocol {

    // MARK: Channels API
    typealias ChannelsInfoResult = (Result<ChannelsList, Error>) -> Void
    typealias ChannelInfoResult = (Result<ChannelInfo, Error>) -> Void
    typealias StringResult = (Result<String, Error>) -> Void
    typealias TokensInfoResult = (Result<[ChannelToken], Error>) -> Void
    typealias TokenInfoResult = (Result<ChannelToken, Error>) -> Void
    typealias ChannelPermissionsResult = (Result<ChannelPermissions, Error>) -> Void

    func getAllChannels(completion: @escaping ChannelsInfoResult)
    func createChannel(createRequest: CreateChannelRequest, retention: Retention,
                       completion: @escaping ChannelInfoResult)
    func amendChannel(channelId: String, permissions: ChannelPermissions,
                      completion: @escaping ChannelPermissionsResult)
    func getChannel(channelId: String,
                    completion: @escaping ChannelInfoResult)
    func deleteChannel(channelId: String,
                       completion: @escaping StringResult)
    func getAllChannelTokens(channelId: String,
                             completion: @escaping TokensInfoResult)
    func getChannelToken(channelId: String, tokenId: String,
                         completion: @escaping TokenInfoResult)
    func createChannelToken(channelId: String, tokenRequest: CreateTokenRequest,
                            completion: @escaping TokenInfoResult)
    func revokeChannelToken(channelId: String, tokenId: String,
                            completion: @escaping StringResult)
}
