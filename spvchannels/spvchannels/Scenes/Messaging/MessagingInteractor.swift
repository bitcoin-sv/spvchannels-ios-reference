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
        let token = spvMessagingApi?.tokenId ?? "n/a"
        presenter?.presentChannelInfo(actionResponse: .init(channelId: channel, tokenId: token))
    }

    func performAction(viewAction: Models.PerformApiAction.ViewAction) {
        presenter?.presentActionResults(actionResponse: .init(result: "some result"))
    }

}
