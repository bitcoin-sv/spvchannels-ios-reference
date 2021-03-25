//
//  ChannelsInteractor.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

import Foundation

final class ChannelsInteractor: ChannelsInteractorType {

    typealias Models = ChannelsModels

    var presenter: ChannelsActionResponses?

    // MARK: - DataStore properties
    var spvChannelsSdk: SpvChannelsSdk?
    var spvChannelApi: SpvChannelApi?

    // MARK: - ViewActions Methods
    func performAction(viewAction: Models.PerformApiAction.ViewAction) {
        switch viewAction.action {
        case .getAllChannels: getAllChannels()
        case .createChannel: createChannel(publicRead: viewAction.publicRead,
                                           publicWrite: viewAction.publicWrite,
                                           sequenced: viewAction.sequenced,
                                           minAge: viewAction.minAge,
                                           maxAge: viewAction.maxAge,
                                           autoPrune: viewAction.autoPrune)
        case .getChannel: getChannel(channelId: viewAction.channelId)
        case .deleteChannel: deleteChannel(channelId: viewAction.channelId)
        case .getAllChannelTokens: getAllChannelTokens(channelId: viewAction.channelId)
        case .amendChannel: amendChannel(channelId: viewAction.channelId,
                                         publicRead: viewAction.publicRead,
                                         publicWrite: viewAction.publicWrite,
                                         locked: viewAction.locked)
        case .createChannelToken: createChannelToken(channelId: viewAction.channelId,
                                                     canRead: viewAction.publicRead,
                                                     canWrite: viewAction.publicWrite,
                                                     tokenDescription: viewAction.tokenDescription)
        case .getChannelToken: getChannelToken(channelId: viewAction.channelId,
                                               tokenId: viewAction.tokenId)
        case .revokeChannelToken: revokeChannelToken(channelId: viewAction.channelId,
                                                     tokenId: viewAction.tokenId)
        }
    }

    // MARK: - API calls
    private func getAllChannels() {
        guard let spvChannelApi = spvChannelApi else { return }
        spvChannelApi.getAllChannels { result in
            var resultStr: String
            switch result {
            case .success(let channels):
                resultStr = channels.jsonString()
            case .failure(let error):
                resultStr = "ERROR: " + APIError.getErrorDescription(from: error)
            }
            self.presenter?.presentActionResults(actionResponse: .init(result: resultStr))
        }
    }

    private func getChannel(channelId: String) {
        guard let spvChannelApi = spvChannelApi else { return }
        spvChannelApi.getChannel(channelId: channelId) { result in
            var resultStr: String
            switch result {
            case .success(let channel):
                resultStr = channel.jsonString()
            case .failure(let error):
                resultStr = "ERROR: " + APIError.getErrorDescription(from: error)
            }
            self.presenter?.presentActionResults(actionResponse: .init(result: resultStr))
        }
    }

    private func deleteChannel(channelId: String) {
        guard let spvChannelApi = spvChannelApi else { return }
        spvChannelApi.deleteChannel(channelId: channelId) { result in
            var resultStr: String
            switch result {
            case .success:
                resultStr = "OK"
            case .failure(let error):
                resultStr = "ERROR: " + APIError.getErrorDescription(from: error)
            }
            self.presenter?.presentActionResults(actionResponse: .init(result: resultStr))
        }
    }

    private func createChannel(publicRead: Bool,
                               publicWrite: Bool,
                               sequenced: Bool,
                               minAge: String,
                               maxAge: String,
                               autoPrune: Bool) {
        guard let spvChannelApi = spvChannelApi else { return }
        guard let retention = Retention(minAgeDays: minAge,
                                        maxAgeDays: maxAge,
                                        autoPrune: autoPrune) else {
            self.presenter?.presentError(errorMessage: "Valid retention info is required")
            return
        }
        let createChannelRequest = CreateChannelRequest(publicRead: publicRead,
                                                        publicWrite: publicWrite,
                                                        sequenced: sequenced)
        spvChannelApi.createChannel(createRequest: createChannelRequest, retention: retention) { result in
            var resultStr: String
            switch result {
            case .success(let channel):
                resultStr = channel.jsonString()
            case .failure(let error):
                resultStr = "ERROR: " + APIError.getErrorDescription(from: error)
            }
            self.presenter?.presentActionResults(actionResponse: .init(result: resultStr))
        }
    }

    private func createChannelToken(channelId: String,
                                    canRead: Bool,
                                    canWrite: Bool,
                                    tokenDescription: String) {
        guard let spvChannelApi = spvChannelApi else { return }
        let tokenRequest = CreateTokenRequest(canRead: canRead, canWrite: canWrite, description: tokenDescription)
        spvChannelApi.createChannelToken(channelId: channelId, tokenRequest: tokenRequest) { result in
            var resultStr: String
            switch result {
            case .success(let channel):
                resultStr = channel.jsonString()
            case .failure(let error):
                resultStr = "ERROR: " + APIError.getErrorDescription(from: error)
            }
            self.presenter?.presentActionResults(actionResponse: .init(result: resultStr))
        }
    }

    private func getAllChannelTokens(channelId: String) {
        guard let spvChannelApi = spvChannelApi else { return }
        spvChannelApi.getChannel(channelId: channelId) { result in
            var resultStr: String
            switch result {
            case .success(let channel):
                resultStr = channel.jsonString()
            case .failure(let error):
                resultStr = "ERROR: " + APIError.getErrorDescription(from: error)
            }
            self.presenter?.presentActionResults(actionResponse: .init(result: resultStr))
        }
    }

    private func amendChannel(channelId: String, publicRead: Bool, publicWrite: Bool, locked: Bool) {
        guard let spvChannelApi = spvChannelApi else { return }
        let permissions = ChannelPermissions(publicRead: publicRead, publicWrite: publicWrite, locked: locked)
        spvChannelApi.amendChannel(channelId: channelId, permissions: permissions) { result in
            var resultStr: String
            switch result {
            case .success(let channelPermissions):
                resultStr = channelPermissions.jsonString()
            case .failure(let error):
                resultStr = "ERROR: " + APIError.getErrorDescription(from: error)
            }
            self.presenter?.presentActionResults(actionResponse: .init(result: resultStr))
        }
    }

    private func getChannelToken(channelId: String, tokenId: String) {
        guard let spvChannelApi = spvChannelApi else { return }
        spvChannelApi.getChannelToken(channelId: channelId, tokenId: tokenId) { result in
            var resultStr: String
            switch result {
            case .success(let channel):
                resultStr = channel.jsonString()
            case .failure(let error):
                resultStr = "ERROR: " + APIError.getErrorDescription(from: error)
            }
            self.presenter?.presentActionResults(actionResponse: .init(result: resultStr))
        }
    }

    private func revokeChannelToken(channelId: String, tokenId: String) {
        guard let spvChannelApi = spvChannelApi else { return }
        spvChannelApi.revokeChannelToken(channelId: channelId, tokenId: tokenId) { result in
            var resultStr: String
            switch result {
            case .success:
                resultStr = "OK"
            case .failure(let error):
                resultStr = "ERROR: " + APIError.getErrorDescription(from: error)
            }
            self.presenter?.presentActionResults(actionResponse: .init(result: resultStr))
        }
    }
}
