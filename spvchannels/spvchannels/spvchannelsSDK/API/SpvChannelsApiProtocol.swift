//
//  SpvChannelsApiProtocol.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

import Foundation

extension JSONDecoder {
    convenience init(keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .convertFromSnakeCase) {
        self.init()
        self.keyDecodingStrategy = keyDecodingStrategy
    }
}

protocol SpvChannelsApiProtocol {
    var credentials: SpvCredentials { get set }
    var baseUrl: String { get set }

    // MARK: Channels API
    typealias ChannelsInfoResult = (Result<[ChannelInfo], SpvError>) -> Void
    typealias ChannelInfoResult = (Result<ChannelInfo, SpvError>) -> Void
    typealias VoidResult = (Result<Void, SpvError>) -> Void
    typealias TokensInfoResult = (Result<[ChannelToken], SpvError>) -> Void
    typealias TokenInfoResult = (Result<ChannelToken, SpvError>) -> Void
    typealias ChannelPermissionsResult = (Result<ChannelPermissions, SpvError>) -> Void

    func getAllChannels(accountId: String,
                        completion: @escaping ChannelsInfoResult)
    func createChannel(accountId: String,
                       completion: @escaping ChannelInfoResult)
    func amendChannel(accountId: String, channelId: String, permissions: ChannelPermissions,
                      completion: @escaping VoidResult)
    func getChannel(accountId: String, channelId: String,
                    completion: @escaping ChannelInfoResult)
    func deleteChannel(accountId: String, channelId: String,
                       completion: @escaping VoidResult)
    func getAllChannelTokens(accountId: String, channelId: String,
                             completion: @escaping TokensInfoResult)
    func getChannelToken(accountId: String, channelId: String, tokenId: String,
                         completion: @escaping TokenInfoResult)
    func createChannelToken(accountId: String, channelId: String, tokenRequest: CreateTokenRequest,
                            completion: @escaping TokenInfoResult)
    func revokeChannelToken(accountId: String, channelId: String, tokenId: String,
                            completion: @escaping VoidResult)
    // MARK: Messaging API

}
