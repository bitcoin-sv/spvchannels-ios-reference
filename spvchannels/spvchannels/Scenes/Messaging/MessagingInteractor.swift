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
            sendMessage()
        case .markMessageRead:
            markMessageRead()
        case .deleteMessage:
            deleteMessage()
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

    func markMessageRead() {
        presenter?.presentActionResults(actionResponse: .init(result: .success(#function + "TODO")))
    }

    func deleteMessage() {
        presenter?.presentActionResults(actionResponse: .init(result: .success(#function + "TODO")))
    }

    func sendMessage() {
        presenter?.presentActionResults(actionResponse: .init(result: .success(#function + "TODO")))
    }

}
