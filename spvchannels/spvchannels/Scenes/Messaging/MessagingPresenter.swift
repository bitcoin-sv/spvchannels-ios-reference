//
//  MessagingPresenter.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

import Foundation

final class MessagingPresenter: MessagingActionResponses {

    typealias Models = MessagingModels
    weak var viewController: MessagingResponseDisplays?

    func presentChannelInfo(actionResponse: MessagingModels.GetChannelInfo.ActionResponse) {
        viewController?.displayChannelInfo(responseDisplay: .init(channelId: actionResponse.channelId,
                                                                  tokenId: actionResponse.tokenId))
    }

    func presentActionResults(actionResponse: Models.PerformApiAction.ActionResponse) {
        viewController?.displayActionResults(responseDisplay: .init(result: "some result"))
    }

}
