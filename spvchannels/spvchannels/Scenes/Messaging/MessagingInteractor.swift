//
//  MessagingInteractor.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

import Foundation

final class MessagingInteractor: MessagingInteractorType {

    typealias Models = MessagingModels

    var presenter: MessagingActionResponses?

    // MARK: - DataStore properties
    var spvChannelsSdk: SpvChannelsSdk?
    var spvMessagingApi: SpvMessagingApi?

    // MARK: - ViewActions Methods
    func getChannelInfo(viewAction: Models.GetChannelInfo.ViewAction) {
        let channel = spvMessagingApi?.channelId ?? "n/a" + " on " + (spvChannelsSdk?.baseUrl ?? "n/a")
        let token = spvMessagingApi?.token ?? "n/a"
        presenter?.presentChannelInfo(actionResponse: .init(channelId: channel, tokenId: token))
    }

    func performAction(viewAction: Models.PerformApiAction.ViewAction) {
        switch viewAction.action {
        case .getMaxSequence:
            getMaxSequence()
        case .getAllMessages:
            getAllMessages(unread: viewAction.unreadOnly)
        case .sendMessage:
            if let data = viewAction.payload.data(using: .utf8) {
                sendMessage(contentType: viewAction.contentType,
                            payload: data)
            } else {
                presenter?.presentError(errorMessage: "Can't form Data payload from string")
            }
        case .markMessageRead:
            markMessageRead(sequenceId: viewAction.sequenceId,
                            read: viewAction.markReadUnread,
                            older: viewAction.markOlderMessages)
        case .deleteMessage:
            deleteMessage(sequenceId: viewAction.sequenceId)
        }
    }

    // MARK: - API calls
    func getMaxSequence() {
        guard let spvMessagingApi = spvMessagingApi else { return }
        spvMessagingApi.getMaxSequence { [weak self] result in
            self?.presenter?.presentActionResults(actionResponse: .init(result: result))
        }
    }

    func getAllMessages(unread: Bool) {
        guard let spvMessagingApi = spvMessagingApi else { return }
        spvMessagingApi.getAllMessages(unread: unread) { [weak self] result in
            self?.presenter?.presentActionResults(actionResponse: .init(result: result))
        }
    }

    func markMessageRead(sequenceId: String, read: Bool, older: Bool) {
        guard let spvMessagingApi = spvMessagingApi else { return }
        spvMessagingApi.markMessageRead(sequenceId: sequenceId, read: read, older: older) { [weak self] result in
            self?.presenter?.presentActionResults(actionResponse: .init(result: result))
        }
    }

    func deleteMessage(sequenceId: String) {
        guard let spvMessagingApi = spvMessagingApi else { return }
        spvMessagingApi.deleteMessage(sequenceId: sequenceId) { [weak self] result in
            self?.presenter?.presentActionResults(actionResponse: .init(result: result))
        }
    }

    func sendMessage(contentType: String, payload: Data) {
        guard let spvMessagingApi = spvMessagingApi else { return }
        spvMessagingApi.sendMessage(contentType: contentType, payload: payload) { [weak self] result in
            self?.presenter?.presentActionResults(actionResponse: .init(result: result))
        }
    }

}
